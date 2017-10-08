function estimate_samples = ...
    Generate_random_samples_of_distributions(hyperparameter_estimates, number_of_samples)
% generates samples of the approximate distributions
% Input:
%   hyperparameter_estimates - estimates of the hyperparameters of the
%                              approximate distributions obtained by the 
%                              VB-algorithm
%   number_of_samples - required number of samples
% Output:
%   estimate_samples - generated samples
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

estimate_samples = struct;
estimate_samples.p_feature_in_topic = ...
    zeros([size(hyperparameter_estimates.feature_in_topic), number_of_samples]);
estimate_samples.p_topic_in_category = ...
    zeros([size(hyperparameter_estimates.topic_in_category), number_of_samples]);
estimate_samples.p_category_transition = ...
    zeros([size(hyperparameter_estimates.category_transition), number_of_samples]);

for sample_id = 1 : number_of_samples
    estimate_samples.p_feature_in_topic(:, :, sample_id) = ...
        Generate_random_Dirichlet_distribution_matrix_individ_param(hyperparameter_estimates.feature_in_topic);
    estimate_samples.p_topic_in_category(:, :, sample_id) = ...
        Generate_random_Dirichlet_distribution_matrix_individ_param(hyperparameter_estimates.topic_in_category);
    estimate_samples.p_category_transition(:, :, sample_id) = ...
        Generate_random_Dirichlet_distribution_matrix_individ_param(hyperparameter_estimates.category_transition);
end

end