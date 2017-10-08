function [parameter_estimates, delta] = EM_MCTM(input_data, param, parameter_initialization)
% Input:
%   input_data - vector of cell. n_clips (documents) cells with
%                n_clip_length columns of features (words) id sequence, for
%                example:
%       input_data - 1x100 cell (number of document is 100), where
%       input_data{i} - 500x1 double (length of the i-th document is 500),
%       where
%       input_data{i}(j) - integer ID of a feature (word) on the j-th
%       place, if N is the number of features (words) in the vocabulary,
%       then input_data{i}(j) \in {1, ..., N}
%   param - struct specifying the parameters. param should have the 
%           following fields:
%       param.n_categories - number of categories (behaviours), 
%           (3 is used for the Idiap dataset in the paper, 
%            4 is used for the QMUL dataset in the paper)
%       param.n_topics - number of topics 
%           (10 is used for the Idiap dataset in the paper,
%            8 is used for the QMUL dataset in the paper)
%       param.n_features - number of features (words), i.e. size of the
%           vocabulary
%           (6480 is used for both datasets in the paper)
%       param.initialization_mode - specifies the way to initialise 
%            distributions. Two modes are implemented:
%            initialization_mode == 1 - distribution vectors are set to 
%                numbers from uniform (0, 1) distribution and then 
%                normalised 
%                (this mode is used in the experiments for the paper)
%            initialization_mode == 2 - distribution vectors are
%                initialised as in the Gibbs model. First, counts are set 
%                randomly and then distributions are estimated based on the 
%                counts  
%       param.max_n_iterations - maximum number of iterations
%           (100 is used in the experiments for the paper)
%       param.convergence_threshold - threshold to check convergence
%       param.smoothing_level - a scalar to be added to smooth obtained
%           estimates of the distributions. In the EM-algorithm the 
%           probability of any words not present in the training dataset is 
%           set to 0. If any new words appear in the test dataset the log 
%           likelihood and therefore normality measure of a clip (document) 
%           with new words would be computed as minus infinity. Therefore, 
%           estimates of the distributions obtained by the EM-algorithm 
%           during the training stage are then smoothed to assigne small 
%           probability to all words not observed in the training dataset 
%           to allow test clips (documents) to have new words.
%           (0.000005 is used in the experiments for the paper)
%       param.alpha - hyperparameter of the Dirichlet prior distribution
%           for the topic in category (behaviour) distributions
%       param.beta - hyperparameter of the Dirichlet prior distribution for
%           the feature (word) in topic distributions
%       param.gamma - hyperparameter of the Dirichlet prior distribution
%           for the transition probabilities between categories 
%           (behaviours)
%       param.eta - hyperparameter of the Dirichlet prior distribution for
%           the distribution of the categories (behaviours) for the first 
%           clip (document) 
%   parameter_initialization - optional parameter. If specified it provides
%                              initilised values for the estimates for 
%                              distributions.
%                              parameter_initialization should be struct 
%                              with the following fields:
%       parameter_initialization.p_initial_category - 1 x n_categories
%       parameter_initialization.p_feature_in_topic - n_features x n_topics
%       parameter_initialization.p_topic_in_category - n_topics x
%           n_categories
%       parameter_initialization.p_category_transition - n_categories x
%           n_categories
%
% Output:
%   parameter_estimates - estimates for distributions
%   delta - history of difference between estimates at the successive
%       iterations
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017 


%% Set up

n_clips = size(input_data, 2);

n_categories = param.n_categories;
n_topics = param.n_topics;
n_features = param.n_features;
max_n_iterations = param.max_n_iterations;
convergence_threshold = param.convergence_threshold;


converged = 1;

%% Initialization and memory allocation                                                                                        

if (nargin < 3)
    if (param.initialization_mode == 1)
        parameter_estimates = struct;

        parameter_estimates.p_initial_category = rand(1, n_categories);     % pi = p(z_1 = k)
        parameter_estimates.p_initial_category = ...
            parameter_estimates.p_initial_category / ...
            sum(parameter_estimates.p_initial_category);  

        parameter_estimates.p_feature_in_topic = rand(n_features, n_topics);    % phi = p(x | y)
        parameter_estimates.p_feature_in_topic = ...
            parameter_estimates.p_feature_in_topic * ...
            diag(1 ./ sum(parameter_estimates.p_feature_in_topic));

        parameter_estimates.p_topic_in_category = rand(n_topics, n_categories); % theta = p(y | z)
        parameter_estimates.p_topic_in_category = ...
            parameter_estimates.p_topic_in_category * ...
            diag(1 ./ sum(parameter_estimates.p_topic_in_category));

        parameter_estimates.p_category_transition = rand(n_categories, n_categories);   % psi = p(z_t | z_{t-1})
        parameter_estimates.p_category_transition = ...
            parameter_estimates.p_category_transition * ...
            diag(1 ./ sum(parameter_estimates.p_category_transition));
    else
        parameter_estimates = ...
            Initialize_parameter_estimates_ala_gibbs(input_data, param);
    end
else
    parameter_estimates = parameter_initialization;
end

%% EM iterations

old_parameter_estimates = parameter_estimates;
iteration_num = 0;
delta = [];
while ((converged > convergence_threshold) && ((iteration_num < max_n_iterations) || (max_n_iterations < 1)))
    iteration_num = iteration_num + 1;
    display(['iteration ', num2str(iteration_num)]);
    [parameter_estimates] = EM_iteration_MCTM(input_data, parameter_estimates, param);
    
    converged = Calculate_parameter_estimates_iteration_change(parameter_estimates, old_parameter_estimates);
    delta(end + 1) = converged;
    old_parameter_estimates = parameter_estimates;
end


end
