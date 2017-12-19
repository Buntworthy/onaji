classdef ImageDatabase < handle
    
    properties
        Images = ImageData.empty
        Root
        RegionProposer
        FeatureExtractor
    end
    
    methods
        
        function this = ImageDatabase(root, regionProposer, featureExtractor)
            this.Root = root;
            this.RegionProposer = regionProposer;
            this.FeatureExtractor = featureExtractor;
            
            this.update();
        end
        
        function update(this)
            imageFiles = util.findImages(this.Root);
            if ~isempty(this.Images)
                nonMembers = ~ismember(imageFiles, this.Images);
            else
                nonMembers = true(numel(imageFiles), 1);
            end
            for iImage = 1:numel(nonMembers)
                path = imageFiles{iImage};
                this.Images(end + 1) = ImageData(this.Root, path);
            end
            
            nImages = numel(this.Images);
            p = util.Progress('Updating DB', nImages);
            for iImage = 1:nImages
                thisImage = this.Images(iImage);
                if isempty(thisImage.Features)
                    thisImage.calculateRegions(this.RegionProposer);
                    thisImage.calculateFeatures(this.FeatureExtractor);
                end
                p.update(iImage);
            end
        end
        
        function result = query(this, query)
            imagesToQuery = this.Images;
            queryImages = query.Image;
            % TODO index no longer needed
            indexes = (1:numel(this.Images))';
            
            for iQueryIm = numel(queryImages):-1:1
                imagesToQuery(this.Images == queryImages(iQueryIm)) = [];
                indexes(this.Images == queryImages(iQueryIm)) = [];
            end
             
            distances = zeros(numel(imagesToQuery), 1);
            minRegion = zeros(numel(imagesToQuery), 1);
            for iIm = 1:numel(imagesToQuery)
                iDistances = pdist2(query.Features, imagesToQuery(iIm).Features, 'cosine');
                if size(iDistances, 1) > 1
                    iDistances = min(iDistances);
                end
                [distances(iIm), minRegion(iIm)] = min(iDistances);
            end
            result = table(indexes, imagesToQuery', distances, minRegion);
            result = sortrows(result, 3);
        end
        
        function close(this)
        end
        
        function save(this)
        end
        
    end
end