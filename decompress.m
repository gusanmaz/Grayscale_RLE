function [imgData] = decompress(compCoreData, scanType, bitDepth, rowCnt, colCnt)
    scanMapMat  = scanMap(scanType, rowCnt, colCnt);
    imgData     = zeros(rowCnt, colCnt);
    imgInd1D    = 1;
    dataInd     = 1;
    
    if bitDepth == 8
        dataIndCnt = length(compCoreData);
        while dataInd <= dataIndCnt
            if compCoreData(dataInd) == 255
                repeat  = compCoreData(dataInd + 1);
                value   = compCoreData(dataInd + 2);
                dataInd = dataInd + 3;
            else
                repeat  = 1;
                value   = compCoreData(dataInd);
                dataInd = dataInd + 1;
            end
            for i = 1:repeat
                imgData(scanMapMat(imgInd1D)) = value;
                imgInd1D = imgInd1D + 1;
            end
        end
    end
    
    if bitDepth == 4
        compCoreData8 = cast(ones(1,numel(compCoreData) * 2), 'uint8');
        for i = 1:numel(compCoreData)
            [compCoreData8(2 * i - 1), compCoreData8(2 * i - 0)] = divmod(compCoreData(i), 16); 
        end
        
        dataIndCnt = length(compCoreData8);
        if compCoreData8(dataIndCnt) == 15
            dataIndCnt = dataIndCnt - 1;
        end
        
        dataInd    = 1;
        while dataInd <= dataIndCnt
            if compCoreData8(dataInd) == 15
                repeat  = compCoreData8(dataInd + 1);
                value   = compCoreData8(dataInd + 2);
                dataInd = dataInd + 3;
            else
                repeat  = 1;
                value   = compCoreData8(dataInd);
                dataInd = dataInd + 1;
            end
            for i = 1:repeat
                if imgInd1D > (rowCnt * colCnt)
                    break;
                end
                imgData(scanMapMat(imgInd1D)) = value * 16;
                imgInd1D = imgInd1D + 1;
            end
        end
    end
    
    if bitDepth == 1
        firstVal        = compCoreData(1);
        compCoreData    = compCoreData(2:end);
        pInd = 1;
        currentVal  = firstVal;
        for compInd = 1:numel(compCoreData)
            indRepCnt = compCoreData(compInd);
            for i = 1:indRepCnt
                pInd = pInd + 1;
                imgData(scanMapMat(pInd)) = 128 * currentVal;
            end
            currentVal = (1 - currentVal);
        end
    end
        
end     