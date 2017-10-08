function [parameter_estimates] = EM_iteration_MCTM(input_data, input_parameter_estimates, param)
% one iteration in EM-algorithm
% Input:
%   input_data - input dataset
%   input_parameter_estimates - estimates of the distributions obtained 
%                               at the previous iteration
%   param - struct of the parameters of the algorithm
%   (input_data and param are the same as in EM_MCTM.m)
% Output:
%   parameter_estimates - updated estimates of the distributions
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

%% EM-algorithm iteration

hidden_variable_estimates = E_step_EM_iteration_MCTM(input_data, input_parameter_estimates);

normalisation_constant = ...
    Calculate_normalisation_constant_for_hidden_variable_estimates(hidden_variable_estimates.category);

parameter_estimates = M_step_EM_iteration_MCTM(input_data, hidden_variable_estimates, normalisation_constant, param);

end