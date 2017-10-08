function small_parameter_estimates = ...
    Calculate_small_parameter_estimates(parameter_estimates)
% convert current estimates of distributions into the "small number" format
% treating mantissa and order to improve numerical stability processing
% small numbers (log2 is used for mantissa and order manipulations)
% Input:
%   parameter_estimates - current estimates of distributions
% Output:
%   small_parameter_estimates - converted estimates of distributions into
%                               the "small number" format
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

small_parameter_estimates = struct;

temp = [];
[temp(:, :, 1), temp(:, :, 2)] = log2(parameter_estimates.p_feature_in_topic);
small_parameter_estimates.p_feature_in_topic = struct;
small_parameter_estimates.p_feature_in_topic.mantissa = temp(:, :, 1);
small_parameter_estimates.p_feature_in_topic.order = temp(:, :, 2);

temp = [];
[temp(:, :, 1), temp(:, :, 2)] = log2(parameter_estimates.p_topic_in_category);
small_parameter_estimates.p_topic_in_category = struct;
small_parameter_estimates.p_topic_in_category.mantissa = temp(:, :, 1);
small_parameter_estimates.p_topic_in_category.order = temp(:, :, 2);

temp = [];
[temp(:, :, 1), temp(:, :, 2)] = log2(parameter_estimates.p_category_transition);
small_parameter_estimates.p_category_transition = struct;
small_parameter_estimates.p_category_transition.mantissa = temp(:, :, 1);
small_parameter_estimates.p_category_transition.order = temp(:, :, 2);

temp = [];
[temp(1, :), temp(2, :)] = log2(parameter_estimates.p_initial_category);
small_parameter_estimates.p_initial_category = struct;
small_parameter_estimates.p_initial_category.mantissa = temp(1, :);
small_parameter_estimates.p_initial_category.order = temp(2, :);


end