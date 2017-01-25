function testFormat()

    function str = stripzeros(strin)
        %STRIPZEROS Strip trailing zeros, leaving one digit right of decimal point.
        % Remove trailing zeros while leaving at least one digit to the right of
        % the decimal place.
        
        % Copyright 2010 The MathWorks, Inc.
        
        str = strin;
        n = regexp(str,'\.0*$');
        if ~isempty(n)
            % There is nothing but zeros to the right of place itself.
            % Remove all trailing zeros except for the first one.the decimal place;
            % the value in n is the index of the decimal
            str(n+2:end) = [];
        else
            % There is a non-zero digit to the right of the decimal place.
            m = regexp(str,'0*$');
            if ~isempty(m)
                % There are trailing zeros, and the value in m is the index of
                % the first trailing zero. Remove them all.
                str(m:end) = [];
            end
        end
    end

    %str = stripzeros(deblank(sprintf('%#-10f', 1.567)))
    str = stripzeros(sprintf('%.5f', 1.567))
    str = stripzeros(sprintf('%.5f', 0.0001))
    str = stripzeros(sprintf('%.5f', 10))
end