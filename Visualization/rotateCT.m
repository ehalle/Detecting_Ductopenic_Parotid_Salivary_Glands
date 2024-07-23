function img = rotateCT(img, angle, dim, method)
if (~exist('dim','var')), dim = 1; end
if (~exist('method','var')), method = 'bicubic'; end

if (angle == 0 || angle == 360)
    return
end
img_min = min(img(:));
img = img - img_min;
if(dim == 1)
    init_array = cast(zeros(size(img,2),size(img,3)),'like',img);
    for i = 1: size(img,1)
        pic = init_array;
        pic(:,:) = img(i,:,:);
        pic = imrotate(pic,angle,method,'crop');
        img(i,:,:) = pic(:,:);
    end
elseif(dim == 2)
    init_array = cast(zeros(size(img,1),size(img,3)),'like',img);
    for i = 1: size(img,2)
        pic = init_array;
        pic(:,:) = img(:,i,:);
        pic = imrotate(pic,angle,method,'crop');
        img(:,i,:) = pic(:,:);
    end
else %dim == 3
    init_array = cast(zeros(size(img,1),size(img,2)),'like',img);
    for i = 1: size(img,3)
        pic = init_array;
        pic(:,:) = img(:,:,i);
        pic = imrotate(pic,angle,method,'crop');
        img(:,:,i) = pic(:,:);
    end
end
img = img + img_min;
end