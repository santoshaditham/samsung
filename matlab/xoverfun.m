function xoverKids = xoverfun(parents, options, nvars, FitnessFcn, unused,thisPopulation)
   n=length(parents)/2;
   xoverKids=zeros(n,nvars);
   max=0;
   for j=1:n,
    if(max<5)%crossover only 5 times
        select1 = parents(1,randi(numel(parents)));%select parent1
        select2 = parents(1,randi(numel(parents)));%select parent2
        xover = randi(size(thisPopulation,2)-1);%select crossover point
        for i=1:xover,
            xoverKids(j,i) = thisPopulation(select1,i);%begin to crossoverpoint will have parent1
        end
        for i=xover:size(thisPopulation,2),
            xoverKids(j,i) = thisPopulation(select2,i);%remaining will be parent2
        end
        max=max+1;
    else%remaining copy
        xoverKids(j,:) = thisPopulation(j,:);
    end
   end
end