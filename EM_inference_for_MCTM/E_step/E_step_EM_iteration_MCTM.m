function hidden_variable_estimates = E_step_EM_iteration_MCTM(input_data, input_parameter_estimates)
% performs the E-step of one iteration of the EM-algorithm
% Input:
%   input_data - input dataset
%   input_parameter_estimates - current estimates of the distributions
% Output:
%   hidden_variable_estimates - updated hidden variable estimates
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

disp('E-step...');
hidden_variable_estimates = struct;

disp('small_param');
small_input_parameter_estimates = Calculate_small_parameter_estimates(input_parameter_estimates);

disp('feature_product');
small_p_feature_in_category_product = ...
    Calculate_p_feature_in_category_product(input_data, small_input_parameter_estimates);

disp('alpha');
alpha = Calculate_alpha_EM_MCTM(small_input_parameter_estimates, small_p_feature_in_category_product);
display('beta');
beta = Calculate_beta_EM_MCTM(small_input_parameter_estimates, small_p_feature_in_category_product);

disp('p(z | x_{1:T})');
hidden_variable_estimates.category = ...
    Calculate_p_aposteriori_category_EM_MCTM(alpha, beta);
disp('p(z_t, z_{t-1} | x_{1:T})');
hidden_variable_estimates.transition_categories = ...
    Calculate_p_aposteriori_joint_categories_EM_MCTM(small_input_parameter_estimates, ...
                                                     alpha, beta, small_p_feature_in_category_product);
disp('p(y, z | x_{1:T})');
hidden_variable_estimates.topic_category = ...
    Calculate_p_aposteriori_joint_topic_category_EM_MCTM(input_data, ...
                                                         small_input_parameter_estimates, ...
                                                         alpha, beta);
disp('p(y | x_{1:T})');
hidden_variable_estimates.topic = ...
    Calculate_p_aposteriori_topic_EM_MCTM(hidden_variable_estimates.topic_category);

end
    
                                                 