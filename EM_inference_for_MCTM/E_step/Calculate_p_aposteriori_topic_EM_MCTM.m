function small_p_aposteriori_topic = Calculate_p_aposteriori_topic_EM_MCTM(small_p_aposteriori_joint_topic_category)
% calculates p(y_{i, t} = p | x_{1:T}, Xi^{Old})
% Input:
%   small_p_aposteriori_joint_topic_category - aposteriori
%                                              joint probabilities of 
%                                              topic and category 
%                                              (behaviour) in the "small 
%                                              number" format 
% Output:
%   small_p_aposteriori_topic - aposteriori probability of topic in the
%                               "small number" format
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017


% p(y_{i, t} = p | x_{1:T}, \Xi^{Old}) 
% {i} (j, k) - probability of topic for clip i at moment k be equal j
n_clips = size(small_p_aposteriori_joint_topic_category.mantissa, 2);

if n_clips > 0
    n_categories = size(small_p_aposteriori_joint_topic_category.mantissa{1}, 2);
    n_topics = size(small_p_aposteriori_joint_topic_category.mantissa{1}, 1);
end

small_p_aposteriori_topic = struct;

for clip_id = 1 : n_clips
    clip_length = size(small_p_aposteriori_joint_topic_category.mantissa{clip_id}, 3);
    
    small_cur_p_aposteriori_joint_topic_category = struct;
    small_cur_p_aposteriori_joint_topic_category.mantissa = ...
        small_p_aposteriori_joint_topic_category.mantissa{clip_id};
    small_cur_p_aposteriori_joint_topic_category.order = ...
        small_p_aposteriori_joint_topic_category.order{clip_id};
    
    small_sum = sum_small_values(small_cur_p_aposteriori_joint_topic_category, 2);
    small_temp = struct;
    small_temp.mantissa = reshape(small_sum.mantissa, n_topics, clip_length);
    small_temp.order = reshape(small_sum.order, n_topics, clip_length);
    
    small_p_aposteriori_topic.mantissa{clip_id} = small_temp.mantissa;
    small_p_aposteriori_topic.order{clip_id} = small_temp.order;
end

end

