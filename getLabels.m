function labelData = getLabels(root)
    files = dir(fullfile(root, '*.jpg'));
    filenames = {files.name};
    filenames = cellfun(@(x) fullfile(root, x), filenames', 'UniformOutput', false);
    labelData = struct;
    for iFile = 1:numel(filenames)
        filename = filenames{iFile};
        xmlName = strrep(filename, '.jpg', '.xml');
        s  = xml2struct(xmlName);
        labelData(iFile).filename = filename;
        % loop over obejcts
        for iObj = 1:numel(s.annotation.object)
            xmlBox = s.annotation.object{iObj}.bndbox;
            label = s.annotation.object{iObj}.name.Text;
            label = matlab.lang.makeValidName(label);
            bbox = [str2double(xmlBox.xmin.Text), ...
                    str2double(xmlBox.ymin.Text), ...
                    str2double(xmlBox.xmax.Text) - str2double(xmlBox.xmin.Text), ...
                    str2double(xmlBox.ymax.Text) - str2double(xmlBox.ymin.Text)];
            if isfield(labelData, label)
                labelData(iFile).(label) = [labelData(iFile).(label); bbox];
            else
                labelData(iFile).(label) = bbox;
            end
        end
    end
    labelData = struct2table(labelData);
end