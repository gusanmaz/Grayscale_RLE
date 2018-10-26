function [map] = scanMap(scanType, rowCnt, colCnt)
      pixelCnt  = rowCnt * colCnt;
      % Valid Scan Types
      % Horizontal        -> 1
      % Vertical          -> 2
      % Zigzag            -> 3
      % Parametric zigzag -> 4
      map = zeros(rowCnt, colCnt);
    
    if scanType == 2 % Vertical
        even = false;
        rowInd = 1;
        colInd = 1;
        for seqInd = 1:pixelCnt
            if (rowInd == 0)
                even   = false;
                rowInd = 1;
                colInd = colInd + 1;
            end
            if (rowInd == (rowCnt + 1))
                even   = true;
                rowInd = rowCnt;
                colInd = colInd + 1;
            end
            if (even)
                map(seqInd) = (colInd - 1) * rowCnt + rowInd;
                rowInd      = rowInd - 1;
            else
                map(seqInd) = (colInd - 1) * rowCnt + rowInd;
                rowInd      = rowInd + 1;
            end
        end
    end
    
    if scanType == 1 % Horizontal
        even = false;
        rowInd = 1;
        colInd = 1;
        for seqInd = 1:pixelCnt
            if (colInd == 0)
                even   = false;
                colInd = 1;
                rowInd = rowInd + 1;
            end
            if (colInd == (colCnt + 1))
                even   = true;
                colInd = colCnt;
                rowInd = rowInd + 1;
            end
            if (even)
                map(seqInd) = (colInd - 1) * rowCnt + rowInd;
                colInd      = colInd - 1;
            else
                map(seqInd) = (colInd - 1) * rowCnt + rowInd;
                colInd      = colInd + 1;
            end
        end
    end
    
    if scanType == 3 % Zigzag
        rowInd = 1;
        colInd = 1;
        up     = true;
        for seqInd = 1:pixelCnt
            map(seqInd) = ((colInd - 1) * rowCnt) + rowInd;
            if ~up %Down
                if (colInd == 1) && (rowInd == rowCnt)
                    colInd = colInd + 1;
                    up     = ~up;
                elseif (colInd == 1)
                    rowInd = rowInd + 1;
                    up = ~up;
                elseif (rowInd == rowCnt)
                    colInd = colInd + 1;
                    up = ~up;
                else
                    rowInd = rowInd + 1;
                    colInd = colInd - 1;
                end
            else %Up
                if (rowInd == 1) && (colInd == colCnt)
                    rowInd = rowInd + 1;
                    up     = ~up;
                elseif (rowInd == 1)
                    colInd = colInd + 1;
                    up = ~up;
                elseif (colInd == colCnt)
                    rowInd = rowInd + 1;
                    up = ~up;
                else
                    rowInd = rowInd - 1;
                    colInd = colInd + 1;
                end
            end
        end
    end
end

