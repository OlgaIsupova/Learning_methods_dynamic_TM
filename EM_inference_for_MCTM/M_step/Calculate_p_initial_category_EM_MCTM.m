function p_initial_category = Calculate_p_initial_category_EM_MCTM(...
                                small_p_aposteriori_initial_category,...
                                small_normalisation_constant,...
                                prior_hyperparameter)
% calculates pi = {p(z_1 = k)}_k
% Input:
%   small_p_aposteriori_initial_category - aposteriori probability of the
%                                          initial category (behaviour) in 
%                                          the "small number" format
%   small_normalisation_constant - normalisation constant of the hiddent
%                                  variables in the "small number" format
%   prior_hyperparameter - hyperparameter eta of the prior Dirichlet
%                          distribution for the initial category 
%                          distribution
% Output:
%   p_initial_category - updated estimates of the initial category
%                        distribution pi
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_categories = size(small_p_aposteriori_initial_category.mantissa, 2);

% normalising the posterior distribution
small_sum_repmat = struct;
small_sum_repmat.mantissa = small_normalisation_constant.mantissa * ones(1, n_categories);
small_sum_repmat.order = small_normalisation_constant.order * ones(1, n_categories);

small_p_initial_category = div_element_wise_small_values(small_p_aposteriori_initial_category, small_sum_repmat);

n_initial_category = small_p_initial_category.mantissa .* 2 .^ small_p_initial_category.order;
                                                                                
% updating the parameter
p_initial_category = prior_hyperparameter + n_initial_category - 1;
p_initial_category(p_initial_category < 0) = 0;
p_initial_category = p_initial_category / sum(p_initial_category);

end