function [hessian] = frangiFilterBasedHessian(image, sigma1, sigma2)
    % frangiFilterBasedHessian - Apply Frangi filter to an input image and calculate Hessian-related properties.
    %
    % This function takes an input image and applies the Frangi filter to it
    % to enhance vessel or cylinder-like structures in the image. The Frangi
    % filter is based on the Hessian matrix and is commonly used in medical
    % imaging and computer vision for vessel segmentation and feature
    % extraction.
    %
    % Input:
    %   image - The input image to be filtered.
    %
    % Output:
    %   hessian - A structure containing the filtered image (Iout), scale
    %             information, and optionally, Hessian matrix components (Vx, Vy, Vz).
    %
    % Usage:
    %   hessian = frangiFilterBasedHessian(image)
    %
    % Global Variables:
    %   use_gpu_g - A global variable indicating whether GPU acceleration is
    %               enabled for the filtering process.
    %
    
    possible_path_args = {'image'};
    disp(size(image));

    for i = 1:length(possible_path_args)
        arg_name = possible_path_args{i};
        eval(sprintf('if isa(%1$s, ''char''), %1$s = load_img_from_nii(%1$s); end', arg_name));
    end
    
    myLog('Hessian filter start: %.f seconds\n', myToc);

    options.FrangiScaleRange= [sigma1 sigma2];
    options.FrangiScaleRatio= 1;
    options.BlackWhite= false;
    options.verbose= false;
    
    [Iout, scale] = FrangiFilter3D(image, options);
    hessian.Iout = Iout;
    hessian.scale = scale;
    
    myLog('Hessian filter end: %.f seconds\n', myToc);
end