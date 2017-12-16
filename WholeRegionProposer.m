classdef WholeRegionProposer < RegionProposer
    
    methods
        
        function regions = calculate(~, im)
            imSize = size(im);
            regions = [1, 1, imSize(2), imSize(1)];
        end
        
    end
    
end