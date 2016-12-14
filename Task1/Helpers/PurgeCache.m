function PurgeCache(Params)
%PurgeCache Purges the cach dir
delete(sprintf('%s/*.*', Params.CachePath));
end