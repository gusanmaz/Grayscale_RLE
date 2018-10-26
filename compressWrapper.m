function [compData] = compressWrapper(scanType, imDir, varargin)

    if scanType < 1 || scanType > 4
        error('Scan type should be a number between 1 and 4');
    end
    
    imgData     = imread(imDir);
    imgMetaData = imfinfo(imDir);
    rowCnt      = imgMetaData.Width;
    colCnt      = imgMetaData.Height;
    bitDepth    = imgMetaData.BitDepth;
    header      = uint8(ones(1,6));
    header(1)   = scanType;
    header(2)   = bitDepth;
    
    
    [header(3), header(4)] = divmod(rowCnt, 256);
    [header(5), header(6)] = divmod(colCnt, 256);
    
    if scanType ~= 4
        compCoreData = compress(scanType, imgData, bitDepth);
    else
        allCompCoreData = [];
        horCellCnt  = varargin{1}; 
        verCellCnt  = varargin{2};
        [header(7), header(8)]  = divmod(horCellCnt, 256);
        [header(9), header(10)] = divmod(verCellCnt, 256);
        [colLen, lastColDiff]   = divmod(colCnt, horCellCnt);
        [rowLen, lastRowDiff]   = divmod(rowCnt, verCellCnt);
        
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
                imgCellData      = imgData(yL:yR, xL:xR);
                cellCompData     = compress(3, imgCellData, bitDepth);
                [cellCompDataLen256, cellCompDataLen1] = divmod(numel(cellCompData), 256);
                allCompCoreData    = [allCompCoreData cellCompDataLen256 cellCompDataLen1 cellCompData];
            end
        end
        compCoreData = allCompCoreData;
    end
    compData = [header compCoreData];
    save('compData', 'compData', '-v6');
end
