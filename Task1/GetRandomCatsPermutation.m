function [ ClassIndices ] = GetRandomCatsPermutation(Params)
%GETRANDOMCATSPERMUTATION Gets a random permutation of classes indices

%TODO: What to do with 'snoopy?'
N_CLASSES = 10;
N_TOTAL_CATS = length(GetAllCategories(Params.Data.ROOT_DIR));
Params.Data.ClassIndices = randperm(N_TOTAL_CATS, N_CLASSES); %choose random permutation indexes

end

