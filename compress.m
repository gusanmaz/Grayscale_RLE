function [compData] = compress(scanType, imgData, bitDepth)
    rowCnt   = size(imgData,1);
    colCnt   = size(imgData,2);
    pixelCnt = rowCnt * colCnt;
    
    scanMapMat   = scanMap(scanType, rowCnt, colCnt);
    compCoreData = uint8(zeros(1, pixelCnt)); %wasnot uint8
    pInd         = 1;
    compInd      = 1;
    
    if bitDepth == 8       
        while pInd <= pixelCnt
            pIndVal      = imgData(scanMapMat(pInd));
            pNextInd     = pInd;
            while (pInd <= pixelCnt) && (pNextInd <= pixelCnt) && (imgData(scanMapMat(pNextInd)) == pIndVal)
                pNextInd = pNextInd + 1;
            end
            run = pNextInd - pInd;
            if ((run == 1) || (run == 2)) && pIndVal == 255
                pIndVal = 254;
            end
            if (run == 1)
                compCoreData(compInd) = pIndVal;
                compInd           = compInd + 1;
                pInd = pNextInd;
            elseif (run == 2)
                compCoreData(compInd)     = pIndVal;
                compCoreData(compInd + 1) = pIndVal;
                compInd               = compInd + 2;
                pInd = pNextInd;
            else
                %To be changed
                runD     = double(run);
                iterate  = ceil(runD / 255.00);
                firstRun = run - ((iterate - 1) * 255);
                
                compCoreData(compInd)     = 255;
                compCoreData(compInd + 1) = firstRun;
                compCoreData(compInd + 2) = pIndVal;
                compInd                   = compInd + 3;
                
                for i = 2:iterate
                    compCoreData(compInd)     = 255;
                    compCoreData(compInd + 1) = 255;
                    compCoreData(compInd + 2) = pIndVal;
                    compInd                   = compInd + 3;
                end
                pInd = pNextInd;
            end
        end
        compData = compCoreData(1:(compInd - 1));
    end
    
    if bitDepth == 4
        while pInd <= pixelCnt
            pIndVal      = imgData(scanMapMat(pInd));
            pNextInd     = pInd;
            while (pInd <= pixelCnt) && (pNextInd <= pixelCnt) && (imgData(scanMapMat(pNextInd)) == pIndVal)
                pNextInd = pNextInd + 1;
            end
            run = pNextInd - pInd;
            if ((run == 1) || (run == 2)) && pIndVal == 15
                pIndVal = 14;
            end
            if (run == 1)
                compCoreData(compInd) = pIndVal;
                compInd               = compInd + 1;
                pInd = pNextInd;
            elseif (run == 2)
                compCoreData(compInd)     = pIndVal;
                compCoreData(compInd + 1) = pIndVal;
                compInd                   = compInd + 2;
                pInd = pNextInd;
            else
                %to be changed
                runD = double(run);
                iterate  = ceil(runD / 15.00);
                firstRun = run - ((iterate - 1) * 15);
                
                compCoreData(compInd)     = 15;
                compCoreData(compInd + 1) = firstRun;
                compCoreData(compInd + 2) = pIndVal;
                compInd                   = compInd + 3;
                
                for i = 2:iterate
                    compCoreData(compInd)     = 15;
                    compCoreData(compInd + 1) = 15;
                    compCoreData(compInd + 2) = pIndVal;
                    compInd                   = compInd + 3;
                end           
                pInd = pNextInd;
            end
        end
        
        compData      = compCoreData(1:(compInd - 1));
        compDataLen   = length(compData);
        compDataLenD  = double(compDataLen);
        mergedDataLen = floor(compDataLenD / 2.0);
        oddLen        = false;
        
        if (mergedDataLen * 2) ~= compDataLen
            mergedDataLen = mergedDataLen + 1;
            oddLen        = true;
        end
        
        mergedData = ones(1, mergedDataLen);
        i = 1;
        mergeInd   = 1;
        while i < compDataLen
            mergedData(mergeInd) = (compData(i) * 16) + compData(i + 1);
            mergeInd = mergeInd + 1;
            i = i + 2;
        end
        
        if oddLen
            mergedData(mergeInd) = compData(compDataLen) * 16 + 16;
        end
        compData = mergedData;
    end
    
    if bitDepth == 1
        compInd      = 1;
        pInd         = 1;
        prevPixelVal = imgData(scanMapMat(1));
        runCnt       = 0;
        while pInd <= pixelCnt
            pIndVal = imgData(scanMapMat(pInd));
            if prevPixelVal == pIndVal
                runCnt = runCnt + 1;
            else
                while runCnt > 255
                    compData(compInd)     = 255;
                    compData(compInd + 1) = 0;
                    compInd               = compInd + 2;
                    runCnt                = runCnt - 255;
                end
                compData(compInd)         = runCnt;
                compInd                   = compInd + 1;
                
                prevPixelVal              = pIndVal;
                runCnt                    = 1;
            end
            pInd = pInd + 1;
        end
        compData = [imgData(scanMapMat(1)) compData];
    end
    
    
end


