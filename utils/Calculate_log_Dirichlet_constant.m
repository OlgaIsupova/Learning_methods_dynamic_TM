function log_Dirichlet_constant = Calculate_log_Dirichlet_constant(hyperparameter)

% Calculates the logarithm of the normalisation constant of the Dirichlet
% distribution with parameters equal to hyperparameter
% If hyperparameter is a matrix, its columns are considered as a parameter
% for one Dirichlet distributions. The results is equal to the sum of the
% logarithms of all normalisation constants
% Input:
%   hyperparameter - parameters of the Dirichlet distribution
% Output:
%   log_Dirichlet_constant - logarithm of the normalisation constant of the 
%                            Dirichlet distribution
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

log_Dirichlet_constant = sum(gammaln(sum(hyperparameter)) - sum(gammaln(hyperparameter)));

end