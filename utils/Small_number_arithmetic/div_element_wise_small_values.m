function result = div_element_wise_small_values(dividend, divider)
% function calculates quotient of dividend and divider where divident and
% divider are matrix small values, i.e. consider mantissa and order
% independently
% Input:
%   divident - matrix of small values of dividents, dividend.mantissa - mantissas and 
%              dividend.order - orders
%   divider - matrix of small values of dividers, divider.mantissa -
%             mantissas and divider.order - orders
% Output:
%   result - matrix of element-wise quotient of small values
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

if (~isequal(size(dividend.mantissa), size(divider.mantissa))) 
    error('vector dimentions must agree');
end

result = struct;

result.mantissa = dividend.mantissa ./ divider.mantissa;
result.order = dividend.order - divider.order;

result = recalculate_small_values(result);

end


