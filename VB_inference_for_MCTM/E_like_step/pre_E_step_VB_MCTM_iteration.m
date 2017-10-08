function non_normalised_parameters = pre_E_step_VB_MCTM_iteration(input_hyperparameter_estimates)
% calculates pseudo normilised values, which can be treated as the
% parameters during the variational E-step
% Input:
%   input_hyperparameter_estimates - current estimates of the
%                                    hyperparameters of the approximate 
%                                    distributions
% Output:
%   non_normalised_parameters - additional tilde variables used in the
%                               E-like step in the VB-algorithm
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

display('pre-E-step...');
non_normalised_parameters = struct;

display('tilde pi');
non_normalised_parameters.p_initial_category = ...
    Calculate_exponenta_digamma(input_hyperparameter_estimates.initial_category);
display('tilde phi');
non_normalised_parameters.p_feature_in_topic = ...
    Calculate_exponenta_digamma(input_hyperparameter_estimates.feature_in_topic);
display('tilde theta');
non_normalised_parameters.p_topic_in_category = ...
    Calculate_exponenta_digamma(input_hyperparameter_estimates.topic_in_category);
display('tilde psi');
non_normalised_parameters.p_category_transition = ...
    Calculate_exponenta_digamma(input_hyperparameter_estimates.category_transition);

end