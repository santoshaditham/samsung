filename = 'auction_winners.data';
winners = csvread(filename);
select = randi(size(winners,1));
x0 = winners(select,:);
LB = [2,2,2,2,2,2,2,2,2,2];
UB = [9,9,9,9,9,9,9,9,9,9];
options = psoptimset(@patternsearch);
options.PollingOrder = 'Random';
options.PollMethod = 'GPSPositiveBasis2N';
options.MeshContraction = 1.0;
options.MeshExpansion = 1.0;
options.MaxIter = 1000 * 10;
options.MaxFunEvals = 1000 * 10 * 10;
%options.CompleteSearch = 'On';
optoins.SearchMethod = @GPSPositiveBasis2N;
options.Display = 'final';
options.PlotFcns = {@psplotbestf,@psplotbestx,@psplotfuncount};
options.Vectorized = 'on';
options.UseParallel = 'always';
[x,fval] = patternsearch(@objfun,x0,[],[],[],[],LB,UB,options);