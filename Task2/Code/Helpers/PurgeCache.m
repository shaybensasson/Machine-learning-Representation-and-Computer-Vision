function PurgeCache(Params)
if (nargin == 0) %DEFAULT
    Params.CachePath = './Cache';
end

%PurgeCache Purges the cach dir
delete(sprintf('%s/*.*', Params.CachePath));
end