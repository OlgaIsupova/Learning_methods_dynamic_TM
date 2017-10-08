function small_value = recalculate_small_values(input_data)
% The function recalculate mantissas and
% orders of small values in such a way, that mantissas are in [0.5, 1)
% Input:
%   input_data - struct of small values, i.e. input_data.mantissa -
%                mantissas and input_data.order - orders, but where 
%                absolute values of mantissas may be not in [0.5, 1)
% Output: 
%   small_value - converted input_data to have mantissas in [0.5, 1)
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

small_value = struct;

[f, e] = log2(input_data.mantissa);
small_value.mantissa = f;
small_value.order = input_data.order + e;

small_value.order(small_value.mantissa == 0) = 0;

end