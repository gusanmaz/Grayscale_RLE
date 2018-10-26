dirNames = {'8bit', '4bit', 'bw'};
dirNames = {'4bit'};

for i = 1:numel(dirNames)
     dirName = dirNames{i};
     cd(dirName);
     filesList = dir();
     cd('..');
     listSize  = numel(filesList);
     for k = 1:listSize
         fileName = filesList(k).name;
         if strcmp(fileName, '.') || strcmp(fileName,'..') || strcmp(fileName, '.DS_Store') || strcmp(fileName, 'Thumbs.db')
             continue;
         end
         [compRatio1, rmsdVal1, compT1, decompT1] = evaluate(strcat(dirName, '/', fileName), 1);
         [compRatio2, rmsdVal2, compT2, decompT2] = evaluate(strcat(dirName, '/', fileName), 2);
         [compRatio3, rmsdVal3, compT3, decompT3] = evaluate(strcat(dirName, '/', fileName), 3);
         %[compRatio4, rmsdVal4, compT4, decompT4] = evaluate(strcat(dirName, '/', fileName), 4, 4, 4);
         %[compRatio5, rmsdVal5, compT5, decompT5] = evaluate(strcat(dirName, '/', fileName), 4, 32, 32);
         
         compRatioList = [compRatio1; compRatio2; compRatio3; compRatio4; compRatio5];
         rmsdList      = [rmsdVal1; rmsdVal2; rmsdVal3; rmsdVal4; rmsdVal5];
         compTList     = [compT1; compT2; compT3; compT4; compT5];
         decompTList   = [decompT1; decompT2; decompT3; decompT4; decompT5];
         scanType = {'Horizontal';'Vertical';'Zig zag';'Zigzag 4x4 Cells';'Zigzag 32x32 Cells'};
         
         %disp(dirName);
         %disp(fileName);
         strcat(dirName, '/', fileName)
         table(compRatioList,rmsdList,compTList,decompTList,'RowNames',scanType)
     end
     %cd('..');
end
     