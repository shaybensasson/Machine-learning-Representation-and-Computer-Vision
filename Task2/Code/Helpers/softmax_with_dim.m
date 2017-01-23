function a = softmax_with_dim(X, dim)
%SOFTMAX_WITH_DIM Calc e(x)/sigma(e(x)) on the given dimension

if (nargin == 0)
    X = [0 1 -50; ...
         1 0.5 0];
    dim = 2;
end

numerator = exp(X);
denominator = sum(numerator,dim);

a = bsxfun(@rdivide,numerator,denominator);

end

