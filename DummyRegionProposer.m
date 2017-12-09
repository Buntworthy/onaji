classdef DummyRegionProposer < RegionProposer
    
    methods
        
        function regions = calculate(~, ~)
            regions = round(100*rand(100, 4)) + 1;
        end
        
    end
    
end