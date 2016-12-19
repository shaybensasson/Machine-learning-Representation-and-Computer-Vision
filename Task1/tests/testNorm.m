M = [1 2; 
    3 4];

norm(M(:, 1), 2)

M2 = normc(M);


norm(M2(:,1), 2)
norm(M2(:,2), 2)

sqrt(sum((M2).^2, 1))
