function [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz] = Hessian3D(Volume,Sigma)
%  This function Hessian3D filters the image with an Gaussian kernel
%  followed by calculation of 2nd order gradients, which aprroximates the
%  2nd order derivatives of the image.
% 
% [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz] = Hessian3D(I,Sigma)
% 
% inputs,
%   I : The image volume, class preferable double or single
%   Sigma : The sigma of the gaussian kernel used. If sigma is zero
%           no gaussian filtering.
%
% outputs,
%   Dxx, Dyy, Dzz, Dxy, Dxz, Dyz: The 2nd derivatives
%
% Function is written by D.Kroon University of Twente (June 2009)
% defaults
if nargin < 2, Sigma = 1; end

if(Sigma>0)
    if(isa(Volume,'gpuArray'))
        F=my_imgaussian(Volume,Sigma);
    else
        F=imgaussian(Volume,Sigma);
    end
else
    F=Volume;
end

% Create first and second order diferentiations
Dz=gradient3(F,'z');
Dzz=(gradient3(Dz,'z'));
clear Dz;

Dy=gradient3(F,'y');
Dyy=(gradient3(Dy,'y'));
Dyz=(gradient3(Dy,'z'));
clear Dy;

Dx=gradient3(F,'x');
Dxx=(gradient3(Dx,'x'));
Dxy=(gradient3(Dx,'y'));
Dxz=(gradient3(Dx,'z'));
clear Dx;
      