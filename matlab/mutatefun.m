function mutationChildren = mutatefun(parents, options, nvars, fitfun, state, thisScore, thisPopulation)
    i=0;
    n=size(parents,2);
    mutationChildren=zeros(n,nvars);
    for j=1:n
        if (i==0)
            mutationChildren(j,:) = thisPopulation(parents(j),:);
            select = randi(size(thisPopulation,1));%select one parent
            change = randi(size(thisPopulation,2));%select one value from selected parent
            mutationChildren(j,change) = thisPopulation(select,change);%mutate in child
            i=1;
        else
            mutationChildren(j,:) = thisPopulation(parents(j),:);
        end
    end
end