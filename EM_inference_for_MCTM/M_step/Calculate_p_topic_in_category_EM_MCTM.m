function p_topic_in_category = Calculate_p_topic_in_category_EM_MCTM(small_p_aposteriori_joint_topic_category,...
                                                                     small_normalisation_constant,...
                                                                     param, ...
                                                                     prior_hyperparameter)
% calculates theta = {p(y = p | z = k)}_{p, k}
% Input:
%   small_p_aposteriori_joint_topic_category - aposteriori joint 
%                                              probability of topics and 
%                                              category (behaviour) in the 
%                                              "small number" format
%   small_normalisation_constant - normalisation constant of the hiddent
%                                  variables in the "small number" format
%   param - struct of the parameters of the algorithm
%   prior_hyperparameter - hyperparameter alpha of the prior Dirichlet
%                          distribution for the topic in category 
%                          (behaviour) distribution
% Output:
%   p_topic_in_category - updated estimates of the topic in category 
%                         (behaviour) distribution theta
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017


n_clips = size(small_p_aposteriori_joint_topic_category.mantissa, 2);
n_topics = param.n_topics;
n_categories = param.n_categories;
if (n_clips > 0)
    small_p_topic_in_category = struct;
    small_p_topic_in_category.mantissa = zeros(n_topics, n_categories);
    small_p_topic_in_category.order = zeros(n_topics, n_categories);
else
    p_topic_in_category = (prior_hyperparameter - 1) * ones(n_topics, n_categories);
    p_topic_in_category = p_topic_in_category * diag(1 ./ sum(p_topic_in_category));
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

n_topic_in_category = small_p_topic_in_category.mantissa .* 2 .^ small_p_topic_in_category.order;

p_topic_in_category = n_topic_in_category + prior_hyperparameter - 1;
p_topic_in_category(p_topic_in_category < 0) = 0;
p_topic_in_category = p_topic_in_category * diag(1 ./ sum(p_topic_in_category));

end