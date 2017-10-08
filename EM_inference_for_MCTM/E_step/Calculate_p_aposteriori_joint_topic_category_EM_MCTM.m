function small_p_aposteriori_joint_topic_category = ...
    Calculate_p_aposteriori_joint_topic_category_EM_MCTM(input_data, ...
                                                         small_input_parameter_estimates, ...
                                                         small_alpha, small_beta)
% calculates p(y_{i, t} = p, z_t = k | x_{1:T}, Xi^{Old})
% Input:
%   input_data - input dataset
%   small_input_parameter_estimates - estimates of the distributions in the
%                                     "small number" format
%   small_alpha - auxiliary variable alpha from dynamic programming in the
%                 "small number" format
%   small_beta - auxiliary variable beta from dynamic programming in the
%                "small number" format
% Output:
%   small_p_aposteriori_joint_topic_category - computed aposteriori
%                                              joint probabilities of 
%                                              topic and category 
%                                              (behaviour) in the "small 
%                                              number" format   
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_clips = size(input_data, 2);
[n_topics, n_categories] = size(small_input_parameter_estimates.p_topic_in_category.mantissa);

small_p_aposteriori_joint_topic_category = struct;

small_p_category_transition_transpose = struct;
small_p_category_transition_transpose.mantissa = small_input_parameter_estimates.p_category_transition.mantissa';
small_p_category_transition_transpose.order = small_input_parameter_estimates.p_category_transition.order';

small_p_feature_in_category = ...
    mult_matrix_small_values(small_input_parameter_estimates.p_feature_in_topic, ...
    small_input_parameter_estimates.p_topic_in_category);


for clip_id = 1 : n_clips
    clip_length = size(input_data{clip_id}, 1);
    % p(y_{i, t} = p, z_t = k | x_{1:T}, \Xi^{Old}) 
    % {i} (j, k, l) - probability of category for clip i be equal to k and
    % topic at moment l in clip i be equal j
                                                                                              
    small_p_aposteriori_joint_topic_category.mantissa{clip_id} = zeros(n_topics, n_categories, clip_length);
    small_p_aposteriori_joint_topic_category.order{clip_id} = zeros(n_topics, n_categories, clip_length);
    
    if (clip_id > 1)
        cur_alpha = struct;
        cur_alpha.mantissa = small_alpha.mantissa(clip_id - 1, :);
        cur_alpha.order = small_alpha.order(clip_id - 1, :);
        
        small_p_data_for_previous_clip = ...
            mult_matrix_small_values(cur_alpha, small_p_category_transition_transpose);
    else
        % p initial category
        small_p_data_for_previous_clip = small_input_parameter_estimates.p_initial_category;
    end
    
    if (clip_length > 1)
        token_combination = flip(nchoosek(1:clip_length, clip_length - 1));
    else
        token_combination = [];
    end
    small_p_feature_in_category_except = struct;
    small_p_feature_in_category_except.mantissa = ...
        permute(reshape(...
        small_p_feature_in_category.mantissa(input_data{clip_id}(token_combination', :), :), ...
        clip_length - 1, clip_length, n_categories), [1, 3, 2]);
    small_p_feature_in_category_except.order = permute(...
        reshape(small_p_feature_in_category.order(input_data{clip_id}(token_combination', :), :), ...
        clip_length - 1, clip_length, n_categories), [1, 3, 2]);
    
    small_prod = prod_small_values(small_p_feature_in_category_except, 1);
    small_p_joint_except = struct;
    small_p_joint_except.mantissa = permute(small_prod.mantissa, [3, 2, 1]);
    small_p_joint_except.order = permute(small_prod.order, [3, 2, 1]);
    
    small_current_clip_feature_in_topic = struct;
    small_current_clip_feature_in_topic.mantissa = ...
        permute(repmat(small_input_parameter_estimates.p_feature_in_topic.mantissa(input_data{clip_id}, :)', ...
        1, 1, n_categories), [1, 3, 2]);
    small_current_clip_feature_in_topic.order = ...
        permute(repmat(small_input_parameter_estimates.p_feature_in_topic.order(input_data{clip_id}, :)', ...
        1, 1, n_categories), [1, 3, 2]);
    
    small_p_topic_in_category_repmat = struct;
    small_p_topic_in_category_repmat.mantissa = ...
        repmat(small_input_parameter_estimates.p_topic_in_category.mantissa, 1, 1, clip_length);
    small_p_topic_in_category_repmat.order = ...
        repmat(small_input_parameter_estimates.p_topic_in_category.order, 1, 1, clip_length);
    
    small_temp = struct;
    small_temp.mantissa = [small_current_clip_feature_in_topic.mantissa(:)'; ...
        small_p_topic_in_category_repmat.mantissa(:)'];
    small_temp.order = [small_current_clip_feature_in_topic.order(:)'; ...
        small_p_topic_in_category_repmat.order(:)'];
    
    small_feature_topic_in_category = prod_small_values(small_temp, 1);
    
    small_p_data_except_current_clip = struct;
    small_p_data_except_current_clip.mantissa = ...
        [small_p_data_for_previous_clip.mantissa; small_beta.mantissa(clip_id, :)];
    small_p_data_except_current_clip.order = ...
        [small_p_data_for_previous_clip.order; small_beta.order(clip_id, :)];
    
    small_p_data_except_current_clip = prod_small_values(small_p_data_except_current_clip, 1);
    
    small_p_data_except_current_clip_diag = struct;
    small_p_data_except_current_clip_diag.mantissa = diag(small_p_data_except_current_clip.mantissa);
    small_p_data_except_current_clip_diag.order = diag(small_p_data_except_current_clip.order);
    
    small_data_except_current_values = ...
        mult_matrix_small_values(small_p_joint_except, small_p_data_except_current_clip_diag);
    
    small_data_except_current_values_repmat = struct;
    small_data_except_current_values_repmat.mantissa = ...
        permute(repmat(small_data_except_current_values.mantissa, 1, 1, n_topics), [3 2 1]);
    small_data_except_current_values_repmat.order = ...
        permute(repmat(small_data_except_current_values.order, 1, 1, n_topics), [3 2 1]);
    
    small_temp = struct;
    small_temp.mantissa = [small_feature_topic_in_category.mantissa(:)'; ...
        small_data_except_current_values_repmat.mantissa(:)'];
    small_temp.order = [small_feature_topic_in_category.order(:)'; ...
        small_data_except_current_values_repmat.order(:)'];
    
    small_temp = prod_small_values(small_temp, 1);
    
    small_p_aposteriori_joint_topic_category.mantissa{clip_id} = ...
        reshape(small_temp.mantissa, n_topics, n_categories, clip_length);
    small_p_aposteriori_joint_topic_category.order{clip_id} = ...
        reshape(small_temp.order, n_topics, n_categories, clip_length);                                                                                      
end

end                                                                                               