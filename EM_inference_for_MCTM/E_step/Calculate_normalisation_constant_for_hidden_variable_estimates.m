function small_normalisation_constant = ...
    Calculate_normalisation_constant_for_hidden_variable_estimates(small_p_aposteriori_initial_category)
% function computes normalisation constant for hidden variables used in the
% E-step of the EM-algorithm
% Input:
%   small_p_aposteriori_initial_category - aposteriori distibution of
%                                          initial category (behaviour) in 
%                                          the "small number" format
% Output:
%   small_normalisation_constant - normalisation constant in the "small
%                                  number" format
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

small_normalisation_constant = sum_small_values(small_p_aposteriori_initial_category, 2);

end