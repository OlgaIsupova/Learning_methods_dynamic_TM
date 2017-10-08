function lower_bound_likelihood = Calculate_lower_bound_likelihood(...
                                        hyperparameter_estimates, non_normalised_parameters, ...
                                        normalisation_constant, param)
                                    
% Calculates the current lower bound of the likelihood of the model
% Input:
%   hyperparameter_estimates - current estimates of the hyperparameters of
%                              the approximate distributions
%   non_normalised_parameters - additional tilde variables used in the
%                               E-like step in the VB-algorithm
%   normalisation_constant - normalisation constant of the hidden variables
%   param - struct of the parameters of the algorithm
% Output:
%   lower_bound_likelihood - current lower bound of the likelihood of the 
%                            model
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

display('Lower bound likelihood...');

lower_bound_likelihood = 0;

lower_bound_likelihood = lower_bound_likelihood + ...
    (param.eta - hyperparameter_estimates.initial_category) * log(non_normalised_parameters.p_initial_category)';

lower_bound_likelihood = lower_bound_likelihood + ...
    sum(sum((param.gamma - hyperparameter_estimates.category_transition) .* ...
    log(non_normalised_parameters.p_category_transition)));

lower_bound_likelihood = lower_bound_likelihood + ...
    sum(sum((param.alpha - hyperparameter_estimates.topic_in_category) .* ...
    log(non_normalised_parameters.p_topic_in_category)));

lower_bound_likelihood = lower_bound_likelihood + ...
    sum(sum((param.beta - hyperparameter_estimates.feature_in_topic) .* ...
    log(non_normalised_parameters.p_feature_in_topic)));

lower_bound_likelihood = lower_bound_likelihood - ...
    Calculate_log_Dirichlet_constant(hyperparameter_estimates.initial_category);

lower_bound_likelihood = lower_bound_likelihood - ...
    Calculate_log_Dirichlet_constant(hyperparameter_estimates.category_transition);

lower_bound_likelihood = lower_bound_likelihood - ...
    Calculate_log_Dirichlet_constant(hyperparameter_estimates.topic_in_category);

lower_bound_likelihood = lower_bound_likelihood - ...
    Calculate_log_Dirichlet_constant(hyperparameter_estimates.feature_in_topic);

lower_bound_likelihood = lower_bound_likelihood + ...
    Calculate_natural_log_small_values(normalisation_constant);
                                    
end