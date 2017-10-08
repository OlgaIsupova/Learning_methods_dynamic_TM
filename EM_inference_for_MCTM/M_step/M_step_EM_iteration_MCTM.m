function parameter_estimates = ...
    M_step_EM_iteration_MCTM(input_data, hidden_variable_estimates, normalisation_constant, param)
% M-step for EM-algorithm for dynamic topic model
% Input:
%   input_data - input dataset
%   hidden_variables_estimates - current estimates of the hidden variables
%                                obtained from the E-step
%   normalisation_constant - normalisation constant of the hidden variables
%   param - struct with the parameters of the algorithm
% Output:
%   parameter_estimates - updated estimates of the distributions
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

display('M-step...');
parameter_estimates = struct;

display('pi');
parameter_estimates.p_initial_category = ...
    Calculate_p_initial_category_EM_MCTM(hidden_variable_estimates.category, normalisation_constant, param.eta);
display('phi');
parameter_estimates.p_feature_in_topic = ...
    Calculate_p_feature_in_topic_EM_MCTM(input_data, ...
                                         hidden_variable_estimates.topic, normalisation_constant, param, param.beta);
display('theta');
parameter_estimates.p_topic_in_category = ...
    Calculate_p_topic_in_category_EM_MCTM(hidden_variable_estimates.topic_category, ...
                                          normalisation_constant, param, param.alpha);
display('psi');
parameter_estimates.p_category_transition = ...
    Calculate_p_category_transition_EM_MCTM(hidden_variable_estimates.transition_categories, ...
                                            normalisation_constant, param, param.gamma);

end