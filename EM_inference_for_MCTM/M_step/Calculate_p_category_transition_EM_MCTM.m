function p_category_transition = Calculate_p_category_transition_EM_MCTM(small_p_aposteriori_joint_categories, ...
                                                                         small_normalisation_constant, ...
                                                                         param, ...
                                                                         prior_hyperparameter)
% calculates psi = {p(z_t = k | z_{t-1} = l)}_{k, l}
% Input:
%   small_p_aposteriori_joint_categories - aposteriori joint probability of 
%                                          successive categories 
%                                          (behaviours) in the "small
%                                          number" format
%   small_normalisation_constant - normalisation constant of the hiddent
%                                  variables in the "small number" format
%   param - struct of the parameters of the algorithm
%   prior_hyperparameter - hyperparameter gamma of the prior Dirichlet
%                          distribution for the transition distribution 
%                          between categories (behaviours)
% Output:
%   p_topic_in_category - updated estimates of the transition distribution 
%                         between categories (behaviours) theta
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_categories = param.n_categories;

small_p_category_transition = sum_small_values(small_p_aposteriori_joint_categories, 3);

% normalising the posterior distribution
small_sum_repmat = struct;
small_sum_repmat.mantissa = small_normalisation_constant.mantissa * ones(n_categories, n_categories);
small_sum_repmat.order = small_normalisation_constant.order * ones(n_categories, n_categories);

small_p_category_transition = div_element_wise_small_values(small_p_category_transition, small_sum_repmat);

n_category_transition = small_p_category_transition.mantissa .* 2 .^ small_p_category_transition.order;

p_category_transition = n_category_transition + prior_hyperparameter - 1;
p_category_transition(p_category_transition < 0) = 0;
p_category_transition = p_category_transition * diag(1 ./ sum(p_category_transition));

end