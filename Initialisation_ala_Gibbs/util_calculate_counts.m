function model = util_calculate_counts(input_model, input_data)
% Recalculate counts from input_data and samples
% Input:
%   input_model - struct with initilised counts
%   input_data - input dataset
% Output:
%   model - updated input_model with computed missing counts
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

model = input_model;
n_features = size(model.feature_for_topic_count, 1);
[n_topics, n_categories] = size(model.topic_for_category_count);
n_clips = size(input_data, 2);

% null all counts
model.feature_for_topic_count = zeros(n_features, n_topics);
model.sum_for_topic_count = zeros(1, n_topics);
model.topic_for_category_count = zeros(n_topics, n_categories);
model.category_transition_count = zeros(n_categories, n_categories);
model.sum_for_category_transition_count = zeros(1, n_categories);

% recalculate counts
for clip_id = 1 : n_clips
    category_id = model.category_for_clip_guess(clip_id);
    if (clip_id > 1) 
        category_id_for_previous_clip = model.category_for_clip_guess(clip_id - 1);
        model.category_transition_count(category_id, category_id_for_previous_clip) = ...
            model.category_transition_count(category_id, category_id_for_previous_clip) + 1;
    end
    for token_position = 1 : size(input_data{clip_id}, 1)
        topic_id = model.topic_for_clip_guess{clip_id}(token_position);
        feature_id = input_data{clip_id}(token_position);
        
        model.feature_for_topic_count(feature_id, topic_id) = ...
            model.feature_for_topic_count(feature_id, topic_id) + 1;
        model.topic_for_category_count(topic_id, category_id) = ...
            model.topic_for_category_count(topic_id, category_id) + 1;
    end 
end

model.sum_for_topic_count = sum(model.feature_for_topic_count, 1);
model.sum_for_category_transition_count = sum(model.category_transition_count, 1);

end