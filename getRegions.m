function regions = getRegions(im)
    addpath(genpath('C:\Software\toolbox'));
    addpath(genpath('C:\Software\edges'));
    
    model=load('C:/Software/edges/models/forest/modelBsds'); 
    model=model.model;
    
    model.opts.multiscale=0; 
    model.opts.sharpen=0; 
    model.opts.nThreads=4;

    %% set up opts for edgeBoxes (see edgeBoxes.m)
    opts = edgeBoxes;
    opts.alpha = .625;     % step size of sliding window search
    opts.beta  = .75;     % nms threshold for object proposals
    opts.minScore = .02;  % min score of boxes to detect
    opts.maxBoxes = 1e2;  % max number of boxes to detect

    edgeBoxOutput = edgeBoxes(im,model,opts);
    regions = edgeBoxOutput(:, 1:4) * 1;
    
end