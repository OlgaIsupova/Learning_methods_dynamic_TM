function result = prod_small_values(input_data, calculation_dimension)
% function calculates element-wise product of input_data among calculation_dimension of 
% small values, i.e. considering mantissa and order
% independently 
% Input:
%   input_data - struct of small values, input_data.mantissa - mantissas 
%                and input_data.orders - orders
%   calculation_dimension - dimension among which to perform product
% Output:
%   result - element-wise product of elements of input_data among
%            calculation_dimension
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

MAX_ORDER = 14;

if nargin > 1
    dim = calculation_dimension;
else
    if (size(input_data.mantissa, 1) == 1)
        dim = 2;
    else 
        dim = 1;
    end
end

result = struct;
if (dim == 1)
    result.mantissa = ones(1, size(input_data.mantissa, 2));
    result.order = zeros(1, size(input_data.order, 2));
else
    result.mantissa = ones(size(input_data.mantissa, 1), 1);
    result.order = zeros(size(input_data.order, 1), 1);
end


mantissas = input_data.mantissa;
orders = input_data.order;

switch dim
    case 1
        cur_mantissas = mantissas(1 : min(MAX_ORDER, end), :, :);
        cur_orders = orders(1 : min(MAX_ORDER, end), :, :);
    case 2
        cur_mantissas = mantissas(:, 1 : min(MAX_ORDER, end), :);
        cur_orders = orders(:, 1 : min(MAX_ORDER, end), :);
    case 3
        cur_mantissas = mantissas(:, :, 1 : min(MAX_ORDER, end));
        cur_orders = orders(:, :, 1 : min(MAX_ORDER, end));
end

result.mantissa = prod(cur_mantissas, dim);
result.order = sum(cur_orders, dim);
result = recalculate_small_values(result);
        


for i = 2 : size(input_data.mantissa, dim) / MAX_ORDER
    switch dim
        case 1
            result.mantissa = ...
                prod(cat(dim, result.mantissa, mantissas((i - 1) * MAX_ORDER + 1 : i * MAX_ORDER, :, :)), dim);
            result.order = ...
                sum(cat(dim, result.order, orders((i - 1) * MAX_ORDER + 1 : i * MAX_ORDER, :, :)), dim);
        case 2
            result.mantissa = ...
                prod(cat(dim, result.mantissa, mantissas(:, (i - 1) * MAX_ORDER + 1 : i * MAX_ORDER)), dim);
            result.order = ...
                sum(cat(dim, result.order, orders(:, (i - 1) * MAX_ORDER + 1 : i * MAX_ORDER)), dim);
        case 3
            result.mantissa = ...
                prod(cat(dim, result.mantissa, mantissas(:, :, (i - 1) * MAX_ORDER + 1 : i * MAX_ORDER)), dim);
            result.order = ...
                sum(cat(dim, result.order, orders(:, :, (i - 1) * MAX_ORDER + 1 : i * MAX_ORDER)), dim);
    end
    result = recalculate_small_values(result);
end

i = fix((size(input_data.mantissa, dim) / MAX_ORDER)) * (size(input_data.mantissa, dim) / MAX_ORDER >= 1);
if (i > 0)
    switch dim
        case 1
            result.mantissa = prod(cat(dim, result.mantissa, mantissas(i * MAX_ORDER + 1 : end, :, :)), dim);
            result.order = sum(cat(dim, result.order, orders(i * MAX_ORDER + 1 : end, :, :)), dim);
        case 2
            result.mantissa = prod(cat(dim, result.mantissa, mantissas(:, i * MAX_ORDER + 1 : end, :)), dim);
            result.order = sum(cat(dim, result.order, orders(:, i * MAX_ORDER + 1 : end, :)), dim);
        case 3
            result.mantissa = prod(cat(dim, result.mantissa, mantissas(:, :, i * MAX_ORDER + 1 : end)), dim);
            result.order = sum(cat(dim, result.order, orders(:, :, i * MAX_ORDER + 1 : end)), dim);
    end
    result = recalculate_small_values(result);
end

end

