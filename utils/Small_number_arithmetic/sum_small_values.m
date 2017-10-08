function result = sum_small_values(input_data, calculation_dimension)
% function computes sum of input_data among calculation_dimension for small 
% values, i.e. considering mantissa and order
% independently

% to sum a sequence of small values all terms are convert to have
% equal order (the maxumum one from the whole sequence). sum is then a sum
% of converting mantissas for a mantissa and this minimum order for an
% order

% Input:
%   input_data - struct of small values, input_data.mantissa - mantissas of
%                these values, input_data.order - orders
%   calculation_dimension - dimension among which to compute the sum
% Output:
%   result - sum of input_data among calculation_dimension
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017


if nargin > 1
    dim = calculation_dimension;
else
    if (sum(size(input_data.mantissa) > 1) == 1)
        dim = find(size(input_data.mantissa) > 1);
    else 
        dim = 1;
    end
end

result = struct;

temp_orders = input_data.order;
temp_orders(input_data.mantissa == 0) = intmin;
result.order = max(temp_orders, [], dim);
result.order(result.order == intmin) = 0;

switch dim
    case 1
        substractor = repmat(result.order, size(input_data.order, 1), 1);
    case 2
        substractor = repmat(result.order, 1, size(input_data.order, 2));
    case 3
        substractor = repmat(result.order, 1, 1, size(input_data.order, 3));
end

temp_orders(input_data.mantissa == 0) = substractor(input_data.mantissa == 0);

mantissas = input_data.mantissa .* (2 .^ (temp_orders - substractor));
result.mantissa = sum(mantissas, dim);

result = recalculate_small_values(result);

end


