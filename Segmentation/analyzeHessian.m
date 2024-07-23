function hessianMask = analyzeHessian(rawHessianImage, hessianScale, hessianThreshold)
    % ANALYZEHESSIAN - Analyzes a Hessian image to create a binary mask.
    %
    % This function takes a raw Hessian image and a scaling factor as input,
    % applies a threshold to it, and produces a binary mask where pixels with
    % values above a certain threshold are set to 1, and the rest are set to 0.
    %
    % Inputs:
    %   - rawHessianImage: The raw Hessian image to be analyzed.
    %   - hessianScale: A scaling factor for the threshold.
    %
    % Output:
    %   - hessianMask: The binary mask resulting from the analysis.
    %
    % Example usage:
    %   hessianMask = analyzeHessian(rawHessianImage, hessianScale);
    %
    % Author: Elia Halle
    % Date: YYYY-MM-DD
    
    myLog('Hessian analayze start: %.f seconds', myToc);
    
    possible_path_args = {'rawHessianImage', 'hessianScale'};
    for i = 1:length(possible_path_args)
        arg_name = possible_path_args{i};
        eval(sprintf('if isa(%1$s, ''char''), %1$s = load_img_from_nii(%1$s); end', arg_name));
    end
      
    hessianMask = rawHessianImage > hessianThreshold * hessianScale;

    myLog('Hessian analayze end: %.f seconds', myToc);
end