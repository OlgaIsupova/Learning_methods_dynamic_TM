function [hyperparameter_estimates, lower_bound_likelihood] = ...
    VB_MCTM_iteration(input_data, input_hyperparameter_estimates, param)
% one iteration in variational EM-algorithm
% Input:
%   input_data - input dataset
%   input_hyperparameter_estimates - estimates of the hyperparameters of 
%                                    the approximate distributions obtained 
%                                    at the previous iteration
%   param - struct of the parameters of the algorithm
%   (input_data and param are the same as in VB_MCTM.m)
% Output:
%   hyperparameter_estimates - updated estimates of the hyperparameters of 
%                              the approximate distributions
%   lower_bound_likelihood - current value of the lower bound of the
%                            likelihood
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

non_normalised_parameters = pre_E_step_VB_MCTM_iteration(input_hyperparameter_estimates);

hidden_variable_estimates = E_step_EM_iteration_MCTM(input_data, non_normalised_parameters);

normalisation_constant = ...
    Calculate_normalisation_constant_for_hidden_variable_estimates(hidden_variable_estimates.category);

hyperparameter_estimates = ...
    a_la_M_step_VB_MCTM_iteration(input_data, hidden_variable_estimates, normalisation_constant, param);

new_non_normalised_parameters = pre_E_step_VB_MCTM_iteration(hyperparameter_estimates);

lower_bound_likelihood = ...
    Calculate_lower_bound_likelihood(hyperparameter_estimates, ...
    new_non_normalised_parameters, normalisation_constant, param);

end