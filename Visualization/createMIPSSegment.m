function createMIPSSegment(ROIImage, folderName)
  hessianThreshold = 0.015;
  cleanedROI = segment(ROIImage, folderName, hessianThreshold);
  createMIPS(cleanedROI, folderName, 'Segment');
end