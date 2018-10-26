function [compRatio, rmsdVal, compT, decompT] = evaluate(imDir, scanType, varargin)

tic;
if nargin == 2
    compData = compressWrapper(scanType, imDir);
end

if nargin == 4
    compData = compressWrapper(scanType, imDir, varargin{1}, varargin{2});
end
compT = toc;

imgMetaData  = imfinfo(imDir);
originalSize = imgMetaData.FileSize;
compFile     = dir('compData.mat');
compFileSize = compFile.bytes;
compRatio    = originalSize / compFileSize;

tic;
cdData = decompressWrapper(false);
decompT = toc;

rmsdVal = rmds(compData, cdData);

end

