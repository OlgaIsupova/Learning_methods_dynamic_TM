function small_p_aposteriori_joint_categories = ...
    Calculate_p_aposteriori_joint_categories_EM_MCTM(small_input_parameter_estimates, ...
                                                     small_alpha, small_beta, ...
                                                     small_p_feature_in_category_product)
% calculates p(z_t = k, z_{t-1} = l | x_{1:T}, Xi^{Old})
% Input:
%   small_input_parameter_estimates - estimates of the distributions in the
%                                     "small number" format
%   small_alpha - auxiliary variable alpha from dynamic programming in the
%                 "small number" format
%   small_beta - auxiliary variable beta from dynamic programming in the
%                "small number" format
%   small_p_feature_in_category_product - p(x_t | z_t), probabilities of
%                                         features (words) in categories 
%                                         (behaviours) in the "small 
%                                         number" format
% Output:
%   small_p_aposteriori_joint_categories - computed aposteriori
%                                          joint probabilities of 
%                                          successive categories 
%                                          (behaviours) in the "small 
%                                          number" format   
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_clips = size(small_p_feature_in_category_product.mantissa, 1);
[n_topics, n_categories] = size(small_input_parameter_estimates.p_topic_in_category.mantissa);


% p(z_{t-1} = l, z_t = k | x_{1:T}, \Xi^{Old}) 
% (i, j, k) - probability of category for the clip k be equal to i and 
% category for the clip k-1 be equal to j [n_categories x n_categories x n_clips]
small_p_aposteriori_joint_categories = struct;
small_p_aposteriori_joint_categories.mantissa = zeros(n_categories, n_categories, n_clips);
small_p_aposteriori_joint_categories.order = zeros(n_categories, n_categories, n_clips);

for clip_id = 2 : n_clips   
    small_feature_product_cur = struct;
    small_feature_product_cur.mantissa = small_p_feature_in_category_product.mantissa(clip_id, :);
    small_feature_product_cur.order = small_p_feature_in_category_product.order(clip_id, :);

    small_temp = struct;
    small_temp.mantissa = [small_feature_product_cur.mantissa; small_beta.mantissa(clip_id, :)];
    small_temp.order = [small_feature_product_cur.order; small_beta.order(clip_id, :)];
    
    small_p_data_from_current_clip = prod_small_values(small_temp, 1);
    small_p_data_from_current_clip.mantissa = small_p_data_from_current_clip.mantissa';
    small_p_data_from_current_clip.order = small_p_data_from_current_clip.order';

    cur_alpha = struct;
    cur_alpha.mantissa = small_alpha.mantissa(clip_id - 1, :);
    cur_alpha.order = small_alpha.order(clip_id - 1, :);
    
    small_product = mult_matrix_small_values(small_p_data_from_current_clip, cur_alpha);
    
    small_temp.mantissa = [small_product.mantissa(:)'; ...
        small_input_parameter_estimates.p_category_transition.mantissa(:)'];
    small_temp.order = [small_product.order(:)'; ...
        small_input_parameter_estimates.p_category_transition.order(:)'];
    
    small_temp = prod_small_values(small_temp, 1);
    small_temp.mantissa = reshape(small_temp.mantissa, n_categories, n_categories);
    small_temp.order = reshape(small_temp.order, n_categories, n_categories);
    
    small_p_aposteriori_joint_categories.mantissa(:, :, clip_id) = small_temp.mantissa;
    small_p_aposteriori_joint_categories.order(:, :, clip_id) = small_temp.order;
end 

end                                                                                       