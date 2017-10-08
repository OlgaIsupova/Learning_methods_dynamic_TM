function [result_saliency, result_p_clip_category_profile] = Calculate_saliency_for_test_data(test_data, estimates)
% function compute normality measure on the given test_data based on
% obtained estimates after the training stage
% Input:
%   test_data - test data in the same format as training data:
%               vector of cell. n_clips (documents) cells with
%               n_clip_length columns of features (words) id sequence, for
%               example:
%       test_data - 1x100 cell (number of document is 100), where
%       test_data{i} - 500x1 double (length of the i-th document is 500),
%       where
%       test_data{i}(j) - integer ID of a feature (word) on the j-th
%       place, if N is the number of features (words) in the vocabulary,
%       then input_data{i}(j) \in {1, ..., N}
%   estimates - estimates of the distributions obtained by one of the
%               learning method during the training stage. If Monte Carlo 
%               approximation is used for log likelihood calculation, then 
%               multiple samples of estimates of the distributions are
%               concatenated along the 3rd dimension of the tensors
% Output:
%   result_saliency - vector of normality measure values for each clip in
%                     test_data
%   result_p_clip_category_profile - predictive probability of the category 
%                                    (behavior) for a clip (document)
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

% initialization
n_testing_clips = size(test_data, 2);

n_features = size(estimates.p_feature_in_topic, 1);
[n_topics, n_categories, n_independent_samples] = size(estimates.p_topic_in_category);


small_saliency = struct;
small_saliency.mantissa = 0;
small_saliency.order = 0;
small_saliency = repmat(small_saliency, n_testing_clips + 1, 1);


result_saliency = zeros(n_testing_clips + 1, 1);


small_p_clip_category_profile = struct;
small_p_clip_category_profile.mantissa = zeros(1, n_categories);
small_p_clip_category_profile.order = zeros(1, n_categories);
small_p_clip_category_profile = repmat(small_p_clip_category_profile, n_testing_clips + 1, 1);

temp = [];
[temp(1, :), temp(2, :)] = log2((1 / n_categories) * ones(1, n_categories));

small_p_clip_category_profile(1).mantissa = temp(1, :);
small_p_clip_category_profile(1).order = temp(2, :);


result_p_clip_category_profile = zeros(n_testing_clips + 1, n_categories);
result_p_clip_category_profile(1, :) = ...
    small_p_clip_category_profile(1).mantissa .* 2 .^ small_p_clip_category_profile(1).order;


temp = [];
temp1 = [];
[temp, temp1] = log2(estimates.p_category_transition);

small_p_category_transition = struct;
small_p_category_transition.mantissa = zeros(n_categories, n_categories);
small_p_category_transition.order = zeros(n_categories, n_categories);
small_p_category_transition = repmat(small_p_category_transition, n_independent_samples, 1);
for sample_id = 1 : n_independent_samples
    small_p_category_transition(sample_id).mantissa = temp(:, :, sample_id);
    small_p_category_transition(sample_id).order = temp1(:, :, sample_id);
end

small_p_category_transition_transpose_for_last_sample = struct;
small_p_category_transition_transpose_for_last_sample.mantissa = ...
    small_p_category_transition(n_independent_samples).mantissa';
small_p_category_transition_transpose_for_last_sample.order = ...
    small_p_category_transition(n_independent_samples).order';

small_p_feature_in_category = struct;
small_p_feature_in_category.mantissa = zeros(n_topics, n_categories);
small_p_feature_in_category.order = zeros(n_topics, n_categories);
small_p_feature_in_category = repmat(small_p_feature_in_category, n_independent_samples, 1);
for sample_id = 1 : n_independent_samples
    temp = [];
    [temp(:, :, 1), temp(:, :, 2)] = ...
        log2(estimates.p_feature_in_topic(:, :, sample_id) * estimates.p_topic_in_category(:, :, sample_id));
    small_p_feature_in_category(sample_id).mantissa = temp(:, :, 1);
    small_p_feature_in_category(sample_id).order = temp(:, :, 2);
end


% estimate saliency

for clip_id = 1 : n_testing_clips
    clip_length = size(test_data{clip_id}, 1);
    
    if (clip_length > 0)
    
        small_p_clip_cond_category = struct;
        small_p_clip_cond_category.mantissa = zeros(1, n_categories);
        small_p_clip_cond_category.order = zeros(1, n_categories);
        small_p_clip_cond_category = repmat(small_p_clip_cond_category, n_independent_samples, 1);

        % calculate p(x_{t+1} | z_{t+1}) = \prod_i \sum_y \phi_{x_{i, t+1}, y} *
        % \theta_{y, z_{t+1}}
        for sample_id = 1 : n_independent_samples
            
            small_p_feature_cond_category = struct;
            small_p_feature_cond_category.mantissa = ...
                small_p_feature_in_category(sample_id).mantissa(test_data{clip_id}, :);
            small_p_feature_cond_category.order = ...
                small_p_feature_in_category(sample_id).order(test_data{clip_id}, :); 
            small_product = prod_small_values(small_p_feature_cond_category, 1);

            small_p_clip_cond_category(sample_id).mantissa = small_product.mantissa;
            small_p_clip_cond_category(sample_id).order = small_product.order;    
        end

        small_diag_p_clip_category = struct;
        small_diag_p_clip_category.mantissa = diag(small_p_clip_category_profile(clip_id).mantissa);
        small_diag_p_clip_category.order = diag(small_p_clip_category_profile(clip_id).order);

        % calculate saliency p(x_{t+1} | x_{1:t})
        for sample_id = 1:n_independent_samples
            small_p_category_transition_cond_category = ...
                mult_matrix_small_values(small_p_category_transition(sample_id), small_diag_p_clip_category);
            p_saliency_cond_previous_category = ...
                mult_matrix_small_values(small_p_clip_cond_category(sample_id), ...
                small_p_category_transition_cond_category);
            p_saliency_for_cur_sample = sum_small_values(p_saliency_cond_previous_category, 2);

            temp = struct;
            temp.mantissa = [small_saliency(clip_id + 1).mantissa; p_saliency_for_cur_sample.mantissa];
            temp.order = [small_saliency(clip_id + 1).order; p_saliency_for_cur_sample.order];
            small_saliency(clip_id + 1) = sum_small_values(temp, 1);
        end

        small_saliency(clip_id + 1).mantissa = small_saliency(clip_id + 1).mantissa * (1 / n_independent_samples);
        small_saliency(clip_id + 1) = recalculate_small_values(small_saliency(clip_id + 1));

        % calculate category profile p(z_{t+1} | x_{1 : t+1})
        % for one estimate
        sample_id = n_independent_samples;

        % \sum_{z_t} \psi^s_{z_{t+1}, z_t} * p(z_t | x_{1:t})
        small_p_category_transition_cond_profile = ...
            mult_matrix_small_values(small_p_clip_category_profile(clip_id), ...
            small_p_category_transition_transpose_for_last_sample);
        temp = struct;
        temp.mantissa = [small_p_category_transition_cond_profile.mantissa; ...
            small_p_clip_cond_category(sample_id).mantissa];
        temp.order = [small_p_category_transition_cond_profile.order; ...
            small_p_clip_cond_category(sample_id).order];

        small_p_category_profile_non_normalized = prod_small_values(temp, 1);

        small_sum_p_category_profile = sum_small_values(small_p_category_profile_non_normalized, 2);

        small_sum_p_category_profile_repmat = struct;
        small_sum_p_category_profile_repmat.mantissa = ...
            repmat(small_sum_p_category_profile.mantissa, 1, n_categories);
        small_sum_p_category_profile_repmat.order = ...
            repmat(small_sum_p_category_profile.order, 1, n_categories);

        small_p_clip_category_profile(clip_id + 1) = ...
            div_element_wise_small_values(small_p_category_profile_non_normalized, ...
            small_sum_p_category_profile_repmat);

        result_p_clip_category_profile(clip_id + 1, :) = ...
            small_p_clip_category_profile(clip_id + 1).mantissa .* 2 .^ ...
            small_p_clip_category_profile(clip_id + 1).order;    

        % saliency 1 / N_{t+1} * log(p(x_{t+1} | x_{1:t}))
        result_saliency(clip_id + 1) = ...
            (log2(small_saliency(clip_id + 1).mantissa) + small_saliency(clip_id + 1).order) * (1 / clip_length);
    else
        result_saliency(clip_id + 1) = 0;
        [small_saliency(clip_id + 1).mantissa, small_saliency(clip_id + 1).order] = ...
            log2(result_saliency(clip_id + 1));
        
        % after clip without features all categories have equal probability
        result_p_clip_category_profile(clip_id + 1, :) = (1 / n_categories) * ones(1, n_categories);
        
        temp = [];
        [temp(1, :), temp(2, :)] = log2(result_p_clip_category_profile(clip_id + 1, :));

        small_p_clip_category_profile(clip_id + 1).mantissa = temp(1, :);
        small_p_clip_category_profile(clip_id + 1).order = temp(2, :);
    end
end

result_saliency = result_saliency(2 : end);
result_p_clip_category_profile = result_p_clip_category_profile(2:end, :);

end