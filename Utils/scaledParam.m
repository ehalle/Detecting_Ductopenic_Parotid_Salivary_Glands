function [output] = scaledParam(value)
    global pixelSpacing;

    testedSpacing = 0.2;
    if isempty(pixelSpacing)
        pixelSpacing = testedSpacing;
    end
    output = value * testedSpacing / pixelSpacing;
end

