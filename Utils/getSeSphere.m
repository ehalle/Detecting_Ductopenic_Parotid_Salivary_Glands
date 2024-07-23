function se = getSeSphere(params)
    % returns morphologic operator in the shape of a ball, with the given
    % diameter
    a = params(1);
    b = params(2);
    c = params(3);
    rad=(1/2);
    swa=(a-1)/2; 
    swb=(b-1)/2; 
    swc=(c-1)/2; 
    [x,y,z]=meshgrid(-swa:swa,-swb:swb,-swc:swc); 
    m=sqrt((x/a).^2 + (y/b).^2 + (z/c).^2); 
    shape=(m <= rad); 
    se=strel('arbitrary',shape);
end