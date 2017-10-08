function p_feature_in_topic = Calculate_p_feature_in_topic_EM_MCTM(input_data, ...
                                                                   small_p_aposteriori_topic, ...
                                                                   small_normalisation_constant, ...
                                                                   param, ...
                                                                   prior_hyperparameter)
% calculates phi = {p(x = a | y = p)}_{a, p}
% Input:
%   small_p_aposteriori_topic - aposteriori probability of topics in the 
%                               "small number" format
%   small_normalisation_constant - normalisation constant of the hiddent
%                                  variables in the "small number" format
%   param - struct of the parameters of the algorithm
%   prior_hyperparameter - hyperparameter beta of the prior Dirichlet
%                          distribution for the feature (word) in topic
%                          distribution
% Output:
%   p_feature_in_topic - updated estimates of the feature (word) in topic
%                        distribution phi
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017


n_clips = size(input_data, 2);
n_features = param.n_features;
n_topics = param.n_topics;

if (n_clips > 0)
    small_p_feature_in_topic = struct;
    small_p_feature_in_topic.mantissa = zeros(n_features, n_topics);
    small_p_feature_in_topic.order = zeros(n_features, n_topics);
else 
    p_feature_in_topic = (prior_hyperparameter - 1) * ones(n_features, n_topics);
    p_feature_in_topic = p_feature_in_topic * diag(1 ./ sum(p_feature_in_topic));
    return;
end

% calculate the sum
for clip_id = 1 : n_clips
    clip_length = size(input_data{clip_id}, 1);
    for token_position = 1 : clip_length
        feature_id = input_data{clip_id}(token_position);
        
        small_temp = struct;
        small_temp.mantissa = [small_p_feature_in_topic.mantissa(feature_id, :); ...
            small_p_aposteriori_topic.mantissa{clip_id}(:, token_position)'];
        small_temp.order = [small_p_feature_in_topic.order(feature_id, :); ...
            small_p_aposteriori_topic.order{clip_id}(:, token_position)'];
        
        small_temp = sum_small_values(small_temp, 1);
        
        small_p_feature_in_topic.mantissa(feature_id, :) = small_temp.mantissa;
        small_p_feature_in_topic.order(feature_id, :) = small_temp.order;
    end
end

% normalising the posterior distribution
small_sum_repmat = struct;
small_sum_repmat.mantissa = small_normalisation_constant.mantissa * ones(n_features, n_topics);
small_sum_repmat.order = small_normalisation_constant.order * ones(n_features, n_topics);

small_p_feature_in_topic = div_element_wise_small_values(small_p_feature_in_topic, small_sum_repmat);

n_feature_in_topic = small_p_feature_in_topic.mantissa .* 2 .^ small_p_feature_in_topic.order;
                                                                                        
p_feature_in_topic = n_feature_in_topic + prior_hyperparameter - 1;
p_feature_in_topic(p_feature_in_topic < 0) = 0;
p_feature_in_topic = p_feature_in_topic * diag(1 ./ sum(p_feature_in_topic));

end