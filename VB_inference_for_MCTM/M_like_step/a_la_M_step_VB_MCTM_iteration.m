function hyperparameter_estimates = ...
    a_la_M_step_VB_MCTM_iteration(input_data, hidden_variable_estimates, normalisation_constant, param)
% updates the hyperparameters of the Dirichlet distributions
% Input:
%   input_data - input dataset
%   hidden_variable_estimates - current estimates of the hidden variables
%   normalisation_constant - normalisation constant of the hidden variables
%   param - struct of the parameters of the algorithm
% Output:
%   hyperparameter_estimates - updated estimates of the hyperparameter of
%                              the approximate distributions
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

display('M-step...');
hyperparameter_estimates = struct;

display('eta');
hyperparameter_estimates.initial_category = ...
    Calculate_hyperparameter_initial_category_VB_MCTM(hidden_variable_estimates.category, ...
    normalisation_constant, param.eta);
display('beta');
hyperparameter_estimates.feature_in_topic = ...
    Calculate_hyperparameter_feature_in_topic_VB_MCTM(input_data, hidden_variable_estimates.topic, ...
    normalisation_constant, param, param.beta);
display('alpha');
hyperparameter_estimates.topic_in_category = ...
    Calculate_hyperparameter_topic_in_category_VB_MCTM(hidden_variable_estimates.topic_category, ...
    normalisation_constant, param, param.alpha);
display('gamma');
hyperparameter_estimates.category_transition = ...
    Calculate_hyperparameter_category_transition_VB_MCTM(hidden_variable_estimates.transition_categories, ...
    normalisation_constant, param, param.gamma);

end