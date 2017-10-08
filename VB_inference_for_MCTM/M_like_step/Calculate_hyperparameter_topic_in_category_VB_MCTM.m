function hyperparameter_topic_in_category = Calculate_hyperparameter_topic_in_category_VB_MCTM(...
                                                                    small_p_aposteriori_joint_topic_category, ...
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
%       param.n_topics - number of topics
%       param.n_categories - number of categories
%   prior_hyperparameter - prior hyperparameter for prior distribution of
%       feature in topics
% Output:
%   hyperparameter_topic_in_category - updated hyperparameter value for the
%   posterior distribution of topics in categories 
%   ([number of topics x number of categories])
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_clips = size(small_p_aposteriori_joint_topic_category.mantissa, 2);
n_topics = param.n_topics;
n_categories = param.n_categories;
if (n_clips > 0)
    small_p_topic_in_category = struct;
    small_p_topic_in_category.mantissa = zeros(n_topics, n_categories);
    small_p_topic_in_category.order = zeros(n_topics, n_categories);
else
    hyperparameter_topic_in_category = prior_hyperparameter * ones(n_topics, n_categories);
    return
end


for clip_id = 1 : n_clips
    small_cur_p_aposteriori_joint_topic_category = struct;
    small_cur_p_aposteriori_joint_topic_category.mantissa = ...
        small_p_aposteriori_joint_topic_category.mantissa{clip_id};
    small_cur_p_aposteriori_joint_topic_category.order = ...
        small_p_aposteriori_joint_topic_category.order{clip_id};
    
    small_sum = sum_small_values(small_cur_p_aposteriori_joint_topic_category, 3);
    
    small_temp = struct;
    small_temp.mantissa = [small_p_topic_in_category.mantissa(:)'; small_sum.mantissa(:)'];
    small_temp.order = [small_p_topic_in_category.order(:)'; small_sum.order(:)'];
    
    small_cur_sum = sum_small_values(small_temp, 1);
    
    small_p_topic_in_category.mantissa = reshape(small_cur_sum.mantissa, n_topics, n_categories);
    small_p_topic_in_category.order = reshape(small_cur_sum.order, n_topics, n_categories);
end

% normalising the posterior distribution
small_sum_repmat = struct;
small_sum_repmat.mantissa = small_normalisation_constant.mantissa * ones(n_topics, n_categories);
small_sum_repmat.order = small_normalisation_constant.order * ones(n_topics, n_categories);

small_p_topic_in_category = div_element_wise_small_values(small_p_topic_in_category, small_sum_repmat);

p_topic_in_category = small_p_topic_in_category.mantissa .* 2 .^ small_p_topic_in_category.order;

hyperparameter_topic_in_category = p_topic_in_category + prior_hyperparameter;

end
                                                                