function parameter_estimates = Calculate_vb_parameter_estimates(hyper_parameter_estimates)
% function computes point estimates of the distributions based on the
% hyperparameters of the approximate distributions for the VB-algorithm
% Input:
%   hyper_parameter_estimates - estimates of the hyperparameters of the
%                               approximate distributions
% Output:
%   parameter_estimates - point estimates of the distributions
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

parameter_estimates = struct;
parameter_estimates.p_initial_category = ...
    hyper_parameter_estimates.initial_category / sum(hyper_parameter_estimates.initial_category);
parameter_estimates.p_feature_in_topic = ...
    hyper_parameter_estimates.feature_in_topic * diag(1 ./ sum(hyper_parameter_estimates.feature_in_topic));
parameter_estimates.p_topic_in_category = ...
    hyper_parameter_estimates.topic_in_category * diag(1 ./ sum(hyper_parameter_estimates.topic_in_category));
parameter_estimates.p_category_transition = ...
    hyper_parameter_estimates.category_transition * ...
    diag(1 ./ sum(hyper_parameter_estimates.category_transition));

end