function newx = annealfun(optimValues,problem)
 nodes = [2, 3, 5, 6, 8, 9];
 trial = [];
 for i=1:size(optimValues.temperature,1),
     trial = [trial (optimValues.x(1,i)*optimValues.temperature(i,1))/100];
 end
 for i=1:size(trial,2),
     if (trial(1,i) >= 2 && trial(1,i) <= 9 && round(trial(1,i)) ~= 4 && round(trial(1,i)) ~= 7)
         newx(1,i) = round(trial(1,i));
     else
         selidx = floor((6-1).*rand(1) + 1);
         newx(1,i) = nodes(selidx);
     end    
 end
end