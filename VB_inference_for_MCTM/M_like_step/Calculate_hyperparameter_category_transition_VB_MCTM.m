function hyperparameter_category_transition = Calculate_hyperparameter_category_transition_VB_MCTM(...
                                                            small_p_aposteriori_joint_categories, ...
                                                            small_normalisation_constant, ...
                                                            param, prior_hyperparameter)
% updates hyperparameter value tilde{alpha} for the posterior distribution
% of topics in categories theta(y | z)
% Input: 
%   small_p_aposteriori_joint_topic_category - approximated posterior joint 
%       probability of a topic and category assignment for each token 
%       (in a format of small values),
%       coming from the E-step of the variational EM-algorithm
%   small_normalisation_constant - normalisation constant for approximated
%       posterior distributions, coming from the E-step of the variational
%       EM-algorithm (in a format of small values)
%   param - structure:
%       param.n_categories - number of categories
%   prior_hyperparameter - prior hyperparameter for prior distribution of
%       feature in topics
% Output:
%   hyperparameter_topic_in_category - updated hyperparameter value for the
%   posterior distribution of topics in categories 
%   ([number of topics x number of categories])
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_categories = param.n_categories;

small_p_category_transition = sum_small_values(small_p_aposteriori_joint_categories, 3);

% normalising the posterior distribution
small_sum_repmat = struct;
small_sum_repmat.mantissa = small_normalisation_constant.mantissa * ones(n_categories, n_categories);
small_sum_repmat.order = small_normalisation_constant.order * ones(n_categories, n_categories);

small_p_category_transition = div_element_wise_small_values(small_p_category_transition, small_sum_repmat);

p_category_transition = small_p_category_transition.mantissa .* 2 .^ small_p_category_transition.order;

hyperparameter_category_transition = p_category_transition + prior_hyperparameter;

end