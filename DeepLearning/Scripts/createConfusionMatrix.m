% Example confusion matrix data
% Original
% confMatrix = [6128, 329, 60; 683, 1692, 1055; 165, 1259, 1663];
% ROI
% confMatrix = [6503, 14, 0; 1130, 839, 1461; 0, 255, 2832];
% Segmentation
% confMatrix = [6517, 0, 0; 46, 2996, 388; 0, 233, 2854];
% not pass segmentation 14
% confMatrix = [837, 1870, 37; 144, 471, 414; 0, 357, 672];
% not pass segmentation 5
% confMatrix = [554, 475, 0; 0, 178, 165; 0, 0, 343];
% combine of segmentation with not pass segmentation 5
confMatrix = [7071, 475, 0; 46, 3174, 553; 0, 233, 3197];

% Plot the confusion matrix
figure
imagesc(confMatrix);

colormap(cool);  % You can replace 'jet' with any other built-in colormap

% Add titles and labels
% title('Custom Confusion Matrix');
xlabel('DL Classification');
ylabel({'Experts'' opinion'});

% Convert values to strings and remove extra whitespace
textStrings = num2str(confMatrix(:), '%d');
textStrings = strtrim(cellstr(textStrings));

% Create grid coordinates for the text annotations
[x, y] = meshgrid(1:size(confMatrix, 2), 1:size(confMatrix, 1));

% Display the text annotations with larger font size
hStrings = text(x(:), y(:), textStrings(:), 'HorizontalAlignment', 'center');
set(hStrings, 'FontSize', 14);  % Adjust font size as needed

% Customize text appearance (example: change text color based on value)
midValue = mean(get(gca, 'CLim'));
textColors = repmat(confMatrix(:) > midValue, 1, 3);
set(hStrings, {'Color'}, num2cell(textColors, 2));

% Set axis tick labels
set(gca, 'XTick', 1:3, 'XTickLabel', {'Normal', 'Moderate', 'Severe'}, 'FontSize', 14);
set(gca, 'YTick', 1:3, 'YTickLabel', {'Normal', 'Moderate', 'Severe'}, 'FontSize', 14);


% Adjust axis label font size (example)
set(gca, 'FontSize', 13);  % Adjust axis label font size separately

% Ensure horizontal alignment of axis tick labels
set(gca, 'XTickLabelRotation', 0);  % Set rotation angle to 0 degrees for horizontal alignment
set(gca, 'YTickLabelRotation', 90);  % Set rotation angle to 0 degrees for horizontal alignment

% Adjust square size
axis image;  % Make the axes have equal aspect ratio