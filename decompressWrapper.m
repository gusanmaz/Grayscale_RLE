function [bitmap] = decompressWrapper(showImg, compData)
    if nargin == 1
         compDataStr = load('compData.mat');
         compData    = compDataStr.compData;
    end
    scanType  = compData(1);
    bitDepth  = compData(2);
    rowCnt256 = compData(3);
    rowCnt1   = compData(4);
    colCnt256 = compData(5);
    colCnt1   = compData(6);
    rowCnt    = double(rowCnt256) * 256 + double(rowCnt1);
    colCnt    = double(colCnt256) * 256 + double(colCnt1);
    
    if scanType ~= 4
        bitmap = decompress(compData(7:end), scanType, bitDepth, rowCnt, colCnt);
    else
        bitmap         = zeros(rowCnt, colCnt);
        cellRowCnt256  = compData(7);
        cellRowCnt1    = compData(8);
        cellColCnt256  = compData(9);
        cellColCnt1    = compData(10);
        verCellCnt = double(cellRowCnt256) * 256 + double(cellRowCnt1);
        horCellCnt = double(cellColCnt256) * 256 + double(cellColCnt1);
        [colLen, lastColDiff]   = divmod(colCnt, horCellCnt);
        [rowLen, lastRowDiff]   = divmod(rowCnt, verCellCnt);
        compDataInd = 11;    
        
        for c = 1:verCellCnt
            yL = ((c - 1) * rowLen) + 1;
            yR = yL + rowLen - 1;
            if c == verCellCnt
                yR = yR + lastRowDiff;
            end
            for r = 1:horCellCnt
                xL = ((r - 1) * colLen) + 1;
                xR = xL + colLen - 1;
                if r == horCellCnt
                    xR = xR + lastColDiff;
                end
                cellLen256  = compData(compDataInd);
                cellLen1    = compData(compDataInd + 1);
                compDataInd = compDataInd + 2;
                cellCompDataLen = double(cellLen256) * 256 + double(cellLen1);
                cellImgData = compData(compDataInd:(compDataInd + cellCompDataLen -1));
                bitmap(yL:yR, xL:xR) = decompress(cellImgData, 3, bitDepth, (yR - yL + 1), (xR - xL + 1));
                compDataInd = compDataInd + cellCompDataLen;
            end
        end
    end
     grayBitmap = mat2gray(bitmap);
     if showImg
        imshow(showImg, grayBitmap);
     end
end

