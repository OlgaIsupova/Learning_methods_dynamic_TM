function distribution_matrix = ...
    Generate_random_Dirichlet_distribution_matrix_individ_param(Dirichlet_parameter)
% generate matrix, where each column is a sample of the Dirichlet
% distribution which parameters are specified in the corresponding column
% of Dirichlet_parameter
% Input:
%   Dirichlet_parameter - matrix with columns that are parameters of the
%                         Dirichlet distributions
% Output:
%   distribution_matrix - samples from the Dirichlet distributions
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

distribution_matrix = zeros(size(Dirichlet_parameter));

n_columns = size(Dirichlet_parameter, 2);

for column_id = 1 : n_columns
    distribution_matrix(:, column_id) = Generate_random_Dirichlet_distribution(Dirichlet_parameter(:, column_id));
end

end