function [hyperparameter_estimates] = VB_MCTM(input_data, param, hyperparameter_initialisation)

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
%       param.n_iterations - maximum number of iterations. If less than 1
%           iterates till convergence
%           (100 is used in the experiments for the paper)
%       param.convergence_threshold - threshold to check convergence
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
%   hyperparameter_initialisation - optional parameter. If specified it 
%                                   provides initilised values for the 
%                                   hyperparameters of the approximate 
%                                   distributions.
%                                   hyperparameter_initialisation should be 
%                                   struct with the following fields:
%       hyperparameter_initialisation.initial_category - 1 x n_categories
%       hyperparameter_initialisation.feature_in_topic - n_features x n_topics
%       hyperparameter_initialisation.topic_in_category - n_topics x
%           n_categories
%       hyperparameter_initialisation.category_transition - n_categories x
%           n_categories
%
% Output:
%   hyperparameter_estimates - estimates of the hyperparameters of
%                              approximate distributions
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017 

%% Set up

n_clips = size(input_data, 2);

n_categories = param.n_categories;
n_topics = param.n_topics;
n_features = param.n_features;
max_n_iterations = param.n_iterations;
convergence_threshold = param.convergence_threshold;

converged = 1;
old_likelihood = 1;

alpha = param.alpha;
beta = param.beta;
gamma = param.gamma;
eta = param.eta;


%% Initialization and memory allocation                                                                                        

if (nargin < 3)
    hyperparameter_estimates = struct;
    hyperparameter_estimates.initial_category = ...
        abs(eta + randn(1, n_categories));
    % features counts
    feature_counts = zeros(n_features, 1);
    for clip_id = 1 : n_clips
        clip_length = size(input_data{clip_id}, 1);
        for token_id = 1 : clip_length
            feature_counts(input_data{clip_id}(token_id)) = feature_counts(input_data{clip_id}(token_id)) + 1;
        end
    end
    hyperparameter_estimates.feature_in_topic = ...
        abs(beta + randn(n_features, n_topics)); % [n_features x n_topics]
    hyperparameter_estimates.topic_in_category = ...
        abs(alpha + randn(n_topics, n_categories)); 
    hyperparameter_estimates.category_transition = ...
        abs(gamma + randn(n_categories, n_categories));
else
    hyperparameter_estimates = hyperparameter_initialisation;
end


%% EM-like iterations

iteration_num = 0;
while ((converged > convergence_threshold) && ((iteration_num < max_n_iterations) || (max_n_iterations < 1)))
    iteration_num = iteration_num + 1;
    display(['iteration ', num2str(iteration_num)]);
    [hyperparameter_estimates, lower_bound_likelihood] = ...
        VB_MCTM_iteration(input_data, hyperparameter_estimates, param);
    if (iteration_num > 1)
        if (lower_bound_likelihood < old_likelihood)
            display('ERROR! lower bound likelihood decreased!');
            lower_bound_likelihood
            return;
        end
    end
    converged = abs((lower_bound_likelihood - old_likelihood) / old_likelihood);
    old_likelihood = lower_bound_likelihood;
    lower_bound_likelihood
end

end