nImages = 34;
nRegions = 1;


allFeatures = vertcat(imageDb.Images.Features);
Y = tsne(allFeatures(1:nImages*nRegions,:));
figure;
scatter(Y(:,1), Y(:,2), 20, repelem((1:nImages)', nRegions), 'filled')

Y = Y./range(Y);
Y = Y - min(Y);
outSize = 500;
pad = 40;
bigIm = zeros(outSize + 2*pad, outSize + 2*pad, 3, 'uint8');
imSize = 40;
%%
for iIm = 1:nImages
    disp(iIm);
    regions = imageDb.Images(iIm).Regions;
    im = imageDb.Images(iIm).Image;
    nRegions = size(regions, 1);
    %imCrops = zeros(imSize, imSize, 3, nRegions, 'uint8');
    for iRegion = 1:nRegions
        imCrop = imcrop(im, regions(iRegion, :));
        imSmall = imresize(imCrop, [imSize, imSize]);
        xStart = pad + round(outSize*Y(nRegions*(iIm-1) + iRegion, 1));
        yStart = pad + round(outSize*Y(nRegions*(iIm-1) + iRegion, 2));
        bigIm(xStart:xStart + imSize - 1, ...
                yStart:yStart + imSize - 1, :) = imSmall;
    end
end

figure
imshow(bigIm)