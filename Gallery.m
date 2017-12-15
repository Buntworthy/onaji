classdef Gallery < handle
    
    properties
        Filenames
        BoundingBoxes
    end
    
    methods
        function this = Gallery(input)
            if iscellstr(input)
                % list of filenames to display
                this.Filenames = input;
                this.show();
            elseif iscell(input)
                this.showCellIms(input);
            elseif istable(input)
                % Table of filenames and bounding boxes
                this.Filenames = input{:, 1};
                this.BoundingBoxes = input{:, 2};
                this.showBoundingBox();
            end
        end
        
        function showCellIms(this, cellIms)
            f = figure;
            cols = 5;
            nImages = numel(cellIms);
            rows = ceil(nImages/cols);
            count = 1;
            
            for iIm = 1:nImages
                subplot(rows, cols, iIm)
                imshow(cellIms{iIm}, 'Border', 'tight');
            end
        end
        
        function show(this)
            f = figure;
            nImages = numel(this.Filenames);
            cols = 5;
            rows = ceil(nImages/cols);
            for iIm = 1:nImages
                subplot(rows, cols, iIm)
                imshow(imread(this.Filenames{iIm}), ...
                        'Border', 'tight');
            end
        end
        
        function showBoundingBox(this)
            f = figure;
            nCrops = size(vertcat(this.BoundingBoxes{:}), 1);
            cols = 10;
            rows = ceil(nCrops/cols);
            count = 1;
            for iIm = 1:numel(this.Filenames)
                bboxes = this.BoundingBoxes{iIm};
                if isempty(bboxes)
                    continue;
                end
                im = imread(this.Filenames{iIm});
                for iBox = 1:size(bboxes, 1)
                    subplot(rows, cols, count)
                    imCrop = imcrop(im, bboxes(iBox, :));
                    imshow(imCrop, 'Border', 'tight');
                    count = count + 1;
                end
            end
        end
    end
    
end