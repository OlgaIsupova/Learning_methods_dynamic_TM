function result = Calculate_exponenta_digamma(input)
% calculates the exponenta of the differences of the digamma functions of
% the elements and the sum of the vector:
%   exp(psi(input) - psi(sum(input))) (formulae 23-26 in the paper)
% Input:
%   input - input vector
% Output:
%   result - resulting vector
% Olga Isupova (ihoho89@gmail.com), Danil Kuzin. 2017

result = exp(psi(input) - psi(repmat(sum(input), size(input, 1), 1)));

end