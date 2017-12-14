classdef EdgeBoxRegionProposer < RegionProposer
    
    properties
        Model;
        NRegions;
        Opts;
    end
    
    methods
        
        function this = EdgeBoxRegionProposer(nRegions)
            this.NRegions = nRegions;
            
            addpath(genpath('C:\Software\toolbox'));
            addpath(genpath('C:\Software\edges'));

            model = load('C:/Software/edges/models/forest/modelBsds'); 
            this.Model = model.model;                        
            this.Model.opts.multiscale = 0; 
            this.Model.opts.sharpen = 0; 
            this.Model.opts.nThreads = 4;
            
            this.Opts = edgeBoxes;
            this.Opts.alpha = 0.625;     % step size of sliding window search
            this.Opts.beta = 0.75;     % nms threshold for object proposals
            this.Opts.minScore = 0.02;  % min score of boxes to detect
            this.Opts.maxBoxes = this.NRegions;  % max number of boxes to detect
            this.Opts.minBoxArea = 5000;
        end
        
        function regions = calculate(this, im)
            im = imresize(im, 1);
            edgeBoxOutput = edgeBoxes(im, this.Model, this.Opts);
            regions = 1*edgeBoxOutput(:, 1:4);
        end
        
    end
end