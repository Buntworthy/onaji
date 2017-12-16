classdef MultiRegionProposer < RegionProposer
    
    properties
        ChildProposers = {}
    end
    
    methods
        function this = MultiRegionProposer(varargin)
            this.ChildProposers = varargin;
        end
        
        function regions = calculate(this, im)
            nProposers = numel(this.ChildProposers);
            regions = [];
            for iProposer = 1:nProposers
                proposer = this.ChildProposers{iProposer};
                childRegions = proposer.calculate(im);
                regions = vertcat(regions, childRegions);
            end
        end
        
    end
    
end