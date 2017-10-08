function distribution = Generate_random_Dirichlet_distribution(Dirichlet_parameter)
% generates sample from the Dirichlet distribution
% Input:
%   Dirichlet_parameter - vector of parameters of the Dirichlet
%                         distribution
% Output:
%   distribution - sample from the Dirichlet distribution
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_elements = size(Dirichlet_parameter, 2);
scale = ones(1, n_elements);

distribution = gamrnd(Dirichlet_parameter, scale);

distribution = distribution / sum(distribution);

end