function [IsValid] = IsGetDataCacheValid(Params, CacheParams)
%ISGETDATACACHEVALID Checks that current params and cached agree (if not purges cache dir)
%   Cache validity depends on ClassIndices and S
IsValid = false;
if CacheParams.UseCacheForGetData && ...
        exist(CacheParams.CacheForGetData, 'file')
    
    S = load(CacheParams.CacheForGetData);
    IsValid = isequal(Params.ClassIndices, S.Params.Data.ClassIndices) && ...
        isequal(Params.S, S.Params.Data.S);
    
    if (~IsValid) %Cache is invalid, ClassIndices or S were switched
        PurgeCache(CacheParams);
        fprintf('NOTE: Cache is invalid, ClassIndices or S were changed, clears cache folder ...\n');
    end
    
end

end

