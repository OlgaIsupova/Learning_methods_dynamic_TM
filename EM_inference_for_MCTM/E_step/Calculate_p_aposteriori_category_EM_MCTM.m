function small_p_aposteriori_category = Calculate_p_aposteriori_category_EM_MCTM(alpha, beta)
% calculates aposteriori distribution of category for each clip
% p(z_t = k | x_{1:T}, \Xi^{Old}) (i, j) - probability of category for the 
% clip i be equal to j [n_clips x n_categories]
% Input:
%   alpha - auxiliary variable alpha from dynamic programming in the "small
%           number" format
%   beta - auxiliary variable beta from dynamic programming in the "small
%          number" format
% Output:
%   small_p_aposteriori_category - computed aposteriori distibution of
%                                  category (behaviour) for each clip in 
%                                  the "small number" format
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

small_temp = struct;
small_temp.mantissa = [alpha.mantissa(1, :); beta.mantissa(1, :)];
small_temp.order = [alpha.order(1, :); beta.order(1, :)];

small_p_aposteriori_category = prod_small_values(small_temp, 1);  

end