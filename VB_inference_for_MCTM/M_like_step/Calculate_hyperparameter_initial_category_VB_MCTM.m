function hyperparameter_initial_category = ...
    Calculate_hyperparameter_initial_category_VB_MCTM(...
        small_p_aposteriori_initial_category, ...
        small_normalisation_constant, prior_hyperparameter)
% calculates tilde{eta}
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
%   hyperparameter_initial_category - updated estimates of the 
%                                     hyperparameters tilde{eta} for the 
%                                     approximate initial category
%                                     distribution pi
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_categories = size(small_p_aposteriori_initial_category.mantissa, 2);

% normalising the posterior distribution
small_sum_repmat = struct;
small_sum_repmat.mantissa = small_normalisation_constant.mantissa * ones(1, n_categories);
small_sum_repmat.order = small_normalisation_constant.order * ones(1, n_categories);

small_p_initial_category = div_element_wise_small_values(small_p_aposteriori_initial_category, small_sum_repmat);

p_initial_category = small_p_initial_category.mantissa .* 2 .^ small_p_initial_category.order;
                                                                                
% updating the hyperparameter

hyperparameter_initial_category = prior_hyperparameter + p_initial_category;
                                                                                
end