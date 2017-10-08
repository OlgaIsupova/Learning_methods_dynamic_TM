function natural_log = Calculate_natural_log_small_values(small_value)
% funcion computes natural log of a small value, i.e. a number presented in
% the mantissa/order format of the log2
% Input:
%   small_value - input small value
% Output:
%   natural_log - natural logarithm of the small value
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

natural_log = log(small_value.mantissa) + log(2)*small_value.order;

end