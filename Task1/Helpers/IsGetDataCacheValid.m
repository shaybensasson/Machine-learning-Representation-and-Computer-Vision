function [IsValid] = IsGetDataCacheValid(Params, CacheParams)
%ISGETDATACACHEVALID Checks that current params and cached agree
%   Cache validity depends on ClassIndices and S
IsValid = false;
if CacheParams.UseCacheForGetData && ...
        exist(CacheParams.CacheForGetData, 'file')
    
    S = load(CacheParams.CacheForGetData);
    IsValid = isequal(Params.ClassIndices, S.Params.Data.ClassIndices) && ...
        isequal(Params.S, S.Params.Data.S);
    
end

end

