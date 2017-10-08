function small_p_feature_in_category_product = ...
    Calculate_p_feature_in_category_product(input_data, small_input_parameter_estimates)
% calculates p(x_t | z_t) for all clips
% Input:
%   input_data - input dataset
%   small_input_parameter_estimates - estimates of the distibutions in the
%                                     "small number" format (mantissa and 
%                                     order processed separately)
% Output:
%   small_p_feature_in_category_product - probabilities of features (words)
%                                         in categories (behaviours) 
%                                         marginalising out topics
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

n_clips = size(input_data, 2);

n_categories = size(small_input_parameter_estimates.p_topic_in_category.mantissa, 2);


small_p_feature_in_category = ...
    mult_matrix_small_values(small_input_parameter_estimates.p_feature_in_topic, ...
    small_input_parameter_estimates.p_topic_in_category);

small_p_feature_in_category_product = struct;
small_p_feature_in_category_product.mantissa = zeros(n_clips, n_categories);
small_p_feature_in_category_product.order = zeros(n_clips, n_categories);

for clip_id = 1 : n_clips
                                                                                              
    small_p_feature_in_category_cur = struct;
    small_p_feature_in_category_cur.mantissa = small_p_feature_in_category.mantissa(input_data{clip_id}, :);
    small_p_feature_in_category_cur.order = small_p_feature_in_category.order(input_data{clip_id}, :);
   
    
    small_p_joint_current_clip = prod_small_values(small_p_feature_in_category_cur, 1);
    
    small_p_feature_in_category_product.mantissa(clip_id, :) = small_p_joint_current_clip.mantissa;
    small_p_feature_in_category_product.order(clip_id, :) = small_p_joint_current_clip.order;

end

end