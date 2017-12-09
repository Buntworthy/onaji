classdef RegionProposer < handle
        
    methods (Abstract)
        regions = calculate(this, im);
    end
    
end