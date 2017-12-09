function features = getFeatures(im, net, layer)
    if iscell(im)
        for iIm = 1:numel(im)
            features{iIm} = net.activations(im{iIm}, layer, 'OutputAs', 'channels');
        end
    elseif ndims(im) == 3
        features = net.activations(im, layer, 'OutputAs', 'channels');
    else
        disp('not implemented')
    end
end