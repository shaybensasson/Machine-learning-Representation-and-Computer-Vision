function testSoftmax()

    function a = softmax_with_dim(X, dim)
        numerator = exp(X);
        denominator = sum(numerator,dim);
        
        a = bsxfun(@rdivide,numerator,denominator);
    end

softmax_with_dim([0 1;-5 5;0.5 0.5])
end