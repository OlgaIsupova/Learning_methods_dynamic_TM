function result = Calculate_parameter_estimates_iteration_change(parameter_estimates, old_parameter_estimates)
% function computes change between estimates of distributions obtained at
% successive iterations to analyse convergence
% Input:
%   parameter_estimates - current estimates of distributions
%   old_parameter_estimates - estimates of distributions obtained at the
%                             previous iteration
% Output:
%   result - maximum relative difference between current and old estimates
%            of distributions
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

EPSEPS = 1.0e-3;
result = 0;

result = max(result, ...
            max(abs(parameter_estimates.p_initial_category - old_parameter_estimates.p_initial_category) ...
                ./ max(old_parameter_estimates.p_initial_category, EPSEPS)));
            
result = max(result, ...
            max(max(abs(parameter_estimates.p_feature_in_topic - old_parameter_estimates.p_feature_in_topic) ./ ...
                max(old_parameter_estimates.p_feature_in_topic, EPSEPS))));
            
result = max(result, ...
            max(max(abs(parameter_estimates.p_topic_in_category - old_parameter_estimates.p_topic_in_category) ./ ...
                max(old_parameter_estimates.p_topic_in_category, EPSEPS))));
            
result = max(result, ...
            max(max(abs(parameter_estimates.p_category_transition - old_parameter_estimates.p_category_transition) ./ ...
                max(old_parameter_estimates.p_category_transition, EPSEPS))));

end