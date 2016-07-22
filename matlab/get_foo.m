participants = [1,2,3,4,5,6,7,8,9];
finalvals=[];
for z=1:9,
    fla=[2];fd=[35];fv=[12];
    filename = strcat('foo_',num2str(participants(1,z)),'.out');
    fid = fopen(filename);
    tline = fgets(fid);
    while ischar(tline)
        [C,matches] = strsplit(tline,{'final load avg:','final degree:','final voltage:'},'CollapseDelimiters',true);
        [nrowsC, ncolsC] = cellfun(@size, C);
        [nrowsM, ncolsM] = cellfun(@size, matches);

        if ncolsM>0
            celldataM= cellstr(matches);
            celldataC= cellstr(C);
            [f_in_cell, pos] = textscan(celldataC{2}, '%f');
            [r,c] = size(cell2mat(f_in_cell));
            if pos == length(celldataC{2})
                switch celldataM{1}
                    case 'final load avg:'
                            if r == 1 && (max(f_in_cell{:}) < 5 && max(f_in_cell{:}) > 0)
                                fla = [fla  f_in_cell{:}];
                            else
                                fla = [fla  fla(end)];
                            end
                    case 'final degree:'
                        if r == 1 && (max(f_in_cell{:}) < 90 && max(f_in_cell{:}) > 0)
                            fd = [fd  f_in_cell{:}];
                        else
                            fd = [fd  fd(end)];
                        end
                    case 'final voltage:'
                        if r == 1 && (max(f_in_cell{:}) < 13 && max(f_in_cell{:}) > 0)
                            fv = [fv  f_in_cell{:}];
                        else
                            fv = [fv  fv(end)];
                        end
                    otherwise
                        disp(f_in_cell{:});
                end
            end
        end
        tline = fgets(fid);
    end
    fclose(fid);
    temp = [mean(fla),mean(fv),mean(fd)];
    finalvals = [finalvals; temp];
    %subplot(9,3,z*3-2);bar(fla);title(strcat('load avg on node -',num2str(participants(1,z))));axis([0 3500 0 2]);
    %subplot(9,3,z*3-1);bar(fd);title(strcat('temperature on node -',num2str(participants(1,z))));axis([0 3500 0 100]);
    %subplot(9,3,z*3);bar(fv);title(strcat('voltage on node -',num2str(participants(1,z))));axis([0 3500 0 50]);
end

