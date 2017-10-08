function small_beta = Calculate_beta_EM_MCTM(small_input_parameter_estimates, small_p_feature_in_category_product)
% dynamic programming for computing beta for EM-algorithm
% Input:
%   small_input_parameter_estimates - estimates of the distirubitons in the
%                                     "small number" format
%   small_p_feature_in_category_product - p(x_t | z_t), probabilities of
%                                         features (words) in categories 
%                                         (behaviours) in the "small 
%                                         number" format
% Output:
%   small_beta - computed beta values for dynamic programming in the 
%                "small number" format
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

[n_topics, n_categories] = size(small_input_parameter_estimates.p_topic_in_category.mantissa);
n_clips = size(small_p_feature_in_category_product.mantissa, 1);

% beta_k(t) = p(x_{t+1}, ..., x_T | z_{t+1} = k) (i, j) - beta_j(i) [n_clips x n_categories]
small_beta = struct;
small_beta.mantissa = zeros(n_clips, n_categories);
small_beta.order = zeros(n_clips, n_categories);


temp = [];
[temp(1, :), temp(2, :)] = log2(ones(1, n_categories));

small_beta.mantissa(n_clips, :) = temp(1, :);
small_beta.order(n_clips, :) = temp(2, :);

for clip_id = n_clips - 1 : -1 : 1
    small_feature_product_cur = struct;
    small_feature_product_cur.mantissa = small_p_feature_in_category_product.mantissa(clip_id + 1, :);
    small_feature_product_cur.order = small_p_feature_in_category_product.order(clip_id + 1, :);
    
    small_temp = struct;
    small_temp.mantissa = [small_feature_product_cur.mantissa; small_beta.mantissa(clip_id + 1, :)];
    small_temp.order = [small_feature_product_cur.order; small_beta.order(clip_id + 1, :)];
    
    small_p_data_for_next_clips = prod_small_values(small_temp, 1);
    
    small_temp = mult_matrix_small_values(small_p_data_for_next_clips, ...
        small_input_parameter_estimates.p_category_transition);
    
    small_beta.mantissa(clip_id, :) = small_temp.mantissa;
    small_beta.order(clip_id, :) = small_temp.order;
end

end