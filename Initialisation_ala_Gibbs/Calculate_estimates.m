function [p_feature_in_topic, p_topic_in_category, p_category_transition] = ...
    Calculate_estimates(model, param)
% calculate estimates of all probabilities according to current counts in
% model
% Input:
%   model - struct with initilised counts
%   param - struct with the parameters
% Output:
%   p_feature_in_topic - distributions of features (words) in topics
%   p_topic_in_category - distributions of topics in categories (behaviours)
%   p_category_transition - transitional distributions between categories
%                           (behaviours)
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

% p(feature | topic)
p_feature_in_topic = zeros(param.n_features, param.n_topics);

p_feature_in_topic = (model.feature_for_topic_count + param.beta) * ...
    diag(1 ./ (model.sum_for_topic_count + param.n_features * param.beta));


% p(topic | category)
p_topic_in_category = zeros(param.n_topics, param.n_categories);

p_topic_in_category = (model.topic_for_category_count + param.alpha) * ...
    diag(1 ./ (sum(model.topic_for_category_count) + param.n_topics * param.alpha));

% p(category | category)
p_category_transition = zeros(param.n_categories, param.n_categories);

p_category_transition = ...
    (model.category_transition_count + param.gamma) * ...
    diag(1 ./ (model.sum_for_category_transition_count + param.n_categories * param.gamma));

end