function hyperparameter_feature_in_topic = ...
    Calculate_hyperparameter_feature_in_topic_VB_MCTM(input_data, ...
                                                      small_p_aposteriori_topic, ...
                                                      small_normalisation_constant, ...
                                                      param,...
                                                      prior_hyperparameter)
% updates hyperparameter value tilde{beta} for the posterior distribution
% of features in topics phi(x | y)
% Input: 
%   input_data - input data of visual features in video clips
%   small_p_aposteriori_topic - approximated posterior probability of a
%       topic assignment for each token (in a format of small values),
%       coming from the E-step of the variational EM-algorithm
%   small_normalisation_constant - normalisation constant for approximated
%       posterior distributions, coming from the E-step of the variational
%       EM-algorithm (in a format of small values)
%   param - structure:
%       param.n_features - number of features
%       param.n_topics - number of topics
%   prior_hyperparameter - prior hyperparameter for prior distribution of
%       feature in topics
% Output:
%   hyperparameter_feature_in_topic - updated hyperparameter value for the
%   posterior distribution of features in topics 
%   ([number of features x number of topics])
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_clips = size(input_data, 2);
n_features = param.n_features;
n_topics = param.n_topics;

if (n_clips > 0)
    small_p_feature_in_topic = struct;
    small_p_feature_in_topic.mantissa = zeros(n_features, n_topics);
    small_p_feature_in_topic.order = zeros(n_features, n_topics);
else 
    hyperparameter_feature_in_topic = prior_hyperparameter * ones(n_features, n_topics);
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

p_feature_in_topic = small_p_feature_in_topic.mantissa .* 2 .^ small_p_feature_in_topic.order;
                                                                                        
hyperparameter_feature_in_topic = p_feature_in_topic + prior_hyperparameter;                                                                                        
                                                                                        
end