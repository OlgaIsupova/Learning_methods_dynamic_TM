function estimates = Initialize_parameter_estimates_ala_gibbs(input_data, param)
% initilises estimates of the distributions as in the Gibbs algorithm
% Input:
%   input_data - input dataset
%   param - struc of the parameters 
% (both input parameters are the same as in EM_MCTM.m)
% Output:
%   estimates - initialised estimates of distributions
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017


ala_gibbs_param = param;
ala_gibbs_param.alpha = 0;
ala_gibbs_param.beta = 0;
ala_gibbs_param.gamma = 0;

gibbs_model = Initialize_counts(input_data, ala_gibbs_param);

estimates = struct;
estimates.p_initial_category = rand(1, ala_gibbs_param.n_categories);
estimates.p_initial_category = estimates.p_initial_category / ...
    sum(estimates.p_initial_category);

[estimates.p_feature_in_topic, estimates.p_topic_in_category, ...
    estimates.p_category_transition] = Calculate_estimates(gibbs_model, ala_gibbs_param);

end