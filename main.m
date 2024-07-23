clc
clear
close all

initPath();
groups = ["Basic", "Moderate", "Severe"];

casesArray = getCasesArray();

for i=1:length(casesArray)
    fullPath = casesArray{i};
    try
        folderName = createGlobals(fullPath);

        myLog('Create files for case %s start: %.f seconds', folderName, myToc);
        [imageNii, imageROI, imgWithoutROI] = createFilesForCase(fullPath, folderName);
        myLog('Create files for case %s end: %.f seconds', folderName, myToc);

        % Witout ROI
        myLog('Mips without ROI start: %.f seconds', myToc);
        createMIPSWithOutROI(imgWithoutROI, folderName);
        myLog('Mips without ROI end: %.f seconds', myToc);

        % ROI
        myLog('Mips ROI start: %.f seconds', myToc);
        createMIPSROI(imageROI, folderName);
        myLog('Mips ROI end: %.f seconds', myToc);

        % Segment
        myLog('Mips segment start: %.f seconds', myToc);
        createMIPSSegment(imageROI, folderName);
        myLog('Mips segment end: %.f seconds', myToc);

        % Side view
        createMIPOrigional(imageNii, folderName);
        myLog('Side view was success');  

        fprintf(1,'\n');
    catch e
        fprintf(1,'The identifier was:\n%s\n',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s\n',e.message);
    end
end
