function small_alpha = Calculate_alpha_EM_MCTM(small_input_parameter_estimates, small_p_feature_in_category_product)
% dynamic programming for computing alpha for EM-algorithm
% Input:
%   small_input_parameter_estimates - estimates of the distirubitons in the
%                                     "small number" format
%   small_p_feature_in_category_product - p(x_t | z_t), probabilities of
%                                         features (words) in categories 
%                                         (behaviours) in the "small 
%                                         number" format
% Output:
%   small_alpha - computed alpha values for dynamic programming in the 
%                 "small number" format
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

[n_topics, n_categories] = size(small_input_parameter_estimates.p_topic_in_category.mantissa);
n_clips = size(small_p_feature_in_category_product.mantissa, 1);


% alpha_k(t) = p(x_1, ..., x_t, z_t = k) (i, j) - alpha_j(i) [n_clips x n_categories]
small_alpha = struct;
small_alpha.mantissa = zeros(n_clips, n_categories);
small_alpha.order = zeros(n_clips, n_categories);

if (n_clips > 0)
    small_feature_product_cur = struct;
    small_feature_product_cur.mantissa = small_p_feature_in_category_product.mantissa(1, :);
    small_feature_product_cur.order = small_p_feature_in_category_product.order(1, :);
    
    small_temp = struct;
    small_temp.mantissa = [small_feature_product_cur.mantissa; ...
        small_input_parameter_estimates.p_initial_category.mantissa];
    small_temp.order = [small_feature_product_cur.order; ...
        small_input_parameter_estimates.p_initial_category.order];
    
    small_temp = prod_small_values(small_temp, 1);

    small_alpha.mantissa(1, :) = small_temp.mantissa;
    small_alpha.order(1, :) = small_temp.order;
end

small_p_category_transition_transpose = struct;
small_p_category_transition_transpose.mantissa = ...
    small_input_parameter_estimates.p_category_transition.mantissa';
small_p_category_transition_transpose.order = ...
    small_input_parameter_estimates.p_category_transition.order';

for clip_id = 2 : n_clips
    small_feature_product_cur.mantissa = small_p_feature_in_category_product.mantissa(clip_id, :);
    small_feature_product_cur.order = small_p_feature_in_category_product.order(clip_id, :);
    
    small_temp = struct;
    small_temp.mantissa = small_alpha.mantissa(clip_id - 1, :);
    small_temp.order = small_alpha.order(clip_id - 1, :);
    
    small_p_data_for_previous_clip = ...
        mult_matrix_small_values(small_temp, small_p_category_transition_transpose);
    
    small_temp = struct;
    small_temp.mantissa = [small_feature_product_cur.mantissa; small_p_data_for_previous_clip.mantissa];
    small_temp.order = [small_feature_product_cur.order; small_p_data_for_previous_clip.order];
    
    small_temp = prod_small_values(small_temp, 1);
    
    small_alpha.mantissa(clip_id, :) = small_temp.mantissa;
    small_alpha.order(clip_id, :) = small_temp.order;
end

end