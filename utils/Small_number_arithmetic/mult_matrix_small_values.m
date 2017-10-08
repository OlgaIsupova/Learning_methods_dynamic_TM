function result = mult_matrix_small_values(first_multiplier, second_multiplier)
% function calculate product of two matrix of small values, i.e. consider
% mantissas and orders independently
% Input:
%   first_multiplier - matrix to be the first multiplier
%   second_multiplier - matrix to be the second multiplier
% Output:
%   results - matrix, the matrix product of first_multiplier and
%             second_multiplier
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

if (size(first_multiplier.mantissa, 2) ~= size(second_multiplier.mantissa, 1))
    error('Inner matrix dimenction must agree')
end

n_rows = size(first_multiplier.mantissa, 1);
n_columns = size(second_multiplier.mantissa, 2);

result = struct;
result.mantissa = zeros(n_rows, n_columns);
result.order = zeros(n_rows, n_columns);

for i = 1 : n_rows
    for j = 1 : n_columns
        small_element = struct;
        small_element.mantissa = [first_multiplier.mantissa(i, :); second_multiplier.mantissa(:, j)'];
        small_element.order = [first_multiplier.order(i, :); second_multiplier.order(:, j)'];
        small_product = prod_small_values(small_element, 1);

        small_sum = sum_small_values(small_product, 2);
    
        result.mantissa(i, j) = small_sum.mantissa;
        result.order(i, j) = small_sum.order;
    end
end

result = recalculate_small_values(result);

end


    
    
    
                
                
                
                