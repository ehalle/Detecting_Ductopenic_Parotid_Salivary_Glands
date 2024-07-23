% The function takes a diameter (diam) as inputand returns a 3D ball-shaped
% structuring element (se) suitable for use in morphological image processing
% operations, where the structuring element is centered and its size is determined by the provided diameter.
function se = getSeBall(diam)
    diam = ceil(diam);
    sw=(diam-1)/2; 
    ses2=ceil(diam/2);
    [y,x,z]=meshgrid(-sw:sw,-sw:sw,-sw:sw); 
    m=sqrt(x.^2 + y.^2 + z.^2); 
    b=(m <= m(ses2,ses2,diam)); 
    se=strel('arbitrary',b);
end