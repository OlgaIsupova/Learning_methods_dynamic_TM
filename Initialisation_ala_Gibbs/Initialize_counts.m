function Model = Initialize_counts(input_data, param, data_initialization)
% initialises counts as in the Gibbs sampling algorithm
% Input:
%   input_data - input dataset
%   param - struct of the parameters
%   (both are the same as in EM_MCTM.m)
%   data_initialization - optional parameter. If specified it provides
%                         initilised values for the counts. 
%                         data_initialization should be struct with the
%                         following fields:
%       data_initialization.category_for_clip_guess - 1 x n_clips
%       data_initialization.topic_for_clip_guess - 1 x n_clips cell, where
%           data_initialization.topic_for_clip_guess{i} - clip_length x 1
% Output:
%   Model - struct with initilised counts
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

Model = struct;

n_clips = size(input_data, 2);

if nargin < 3
    Model.category_for_clip_guess = randi(param.n_categories,[1, n_clips]); % category for each clip   [1 x n_clips] 
    for clip_id = 1 : n_clips
        clip_length = size(input_data{clip_id}, 1);
        Model.topic_for_clip_guess{clip_id} = randi(param.n_topics, [clip_length, 1]); % topic for each token in each clip   [clip_length x n_clips]
    end
else
    Model.category_for_clip_guess = data_initialization.category_for_clip_guess;
    Model.topic_for_clip_guess = data_initialization.topic_for_clip_guess;
end

% counts
Model.feature_for_topic_count = zeros(param.n_features, param.n_topics);    % n_{x, y} counts (i, j) - how many times feature i is associated with topic j  [n_features x n_topics]   
Model.sum_for_topic_count = zeros(1, param.n_topics);                       % n_{., y} = sum_x n_{x, y} counts i - how many times topic i occurs in collection. 
                                                                            % sum over columns Model.feature_for_topic_count  [1 x n_topics]

Model.topic_for_category_count = zeros(param.n_topics, param.n_categories); % n_{y, z} counts (i, j) - how many times topic i is associated with category j  [n_topics x n_categories]

Model.category_transition_count = zeros(param.n_categories, param.n_categories);    % n_{z', z} counts (i, j) - how many times category i following category j  [n_categories x n_categories]
Model.sum_for_category_transition_count = zeros(1, param.n_categories);             % n_{., z} counts i - how many times category i has followers. 
                                                                                    % sum over columns Model.category_transition_count   [1 x n_categories]
                                                                                    
Model = util_calculate_counts(Model, input_data);

end
