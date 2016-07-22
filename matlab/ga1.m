
t = cputime;
filename = 'auction_winners.data';
winners = csvread(filename);
intwinners = uint32(winners);
filename = 'auction_bids.data';
bids = csvread(filename);
for i=1:size(bids,1);
 cumulative_bids(i,1) = sum(bids(i,:));
end;
nvars = 10;
options = gaoptimset(@ga);
options.SelectionFcn = {@selectiontournament,nvars};
options.MutationFcn = @mutatefun;
options.CrossoverFcn = @xoverfun;
options.CrossoverFraction = 0.85;
options.Generations = 1000;
options.StallGenLimit = 250;
options.PopulationSize = 100;
options.PopulationType = 'custom';
options.InitialPopulation = intwinners;
options.InitialScores = cumulative_bids;


options.PlotFcns = {@gaplotdistance,@gaplotbestf,@gaplotgenealogy,@gaplotselection};
options.Vectorized = 'on';
options.UseParallel = 'always';
options.Display = 'final';
[x,fval,exitflag,output,population,scores] = ga(@fitfun,nvars,[],[],[],[],[],[],[],options);
e = cputime-t;
% subplot(2,2,2);
% output.Sscores = output.Sscores(:,max(find(output.Sscores(1,:)==0))+1:end);
% hist(output.Sscores);
% title('Fitness Scaling');
