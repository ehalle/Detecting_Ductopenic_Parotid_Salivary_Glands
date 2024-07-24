function createMIPSSegment(ROIImage, folderName)
  cleanedROI = segment(ROIImage, folderName);
  createMIPS(cleanedROI, folderName, 'Segment');
end