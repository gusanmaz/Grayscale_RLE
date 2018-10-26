function [value] = rmds(img1, img2)
imgIndCnt = numel(img1);

sumValues = 0;
for i = 1:imgIndCnt
    diff      = img1(i) - img2(i);
    sumValues = sumValues + (diff * diff);
end
sumValues = double(sumValues);
%class(sumValues);
%class(imgIndCnt);
sumValues = sumValues / imgIndCnt;
value     = sqrt(sumValues);

end

