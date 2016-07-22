

function state = gaplotrange(options,state,flag)
%gaplot1drange Plots the mean and the range of the population.
%   STATE = gaplotrange(OPTIONS,STATE,FLAG) plots the mean and the range
%   (highest and the lowest) of individuals (1-D only).  
%
%   Example:
%   Create an options structure that uses gaplotrange
%   as the plot function
%     options = gaoptimset('PlotFcns',@gaplotrange);

%   Copyright 2012-2014 The MathWorks, Inc.

 if isinf(options.Generations) > 1
     title('Plot Not Available','interp','none');
     return;
 end
 
for i = 1:size(state.Population,1), 
    generation = state.Generation;
    score = state.Population(i,:);
    smean = mean(score);
    Y = smean;
    L = smean - min(score);
    U = max(score) - smean;

    switch flag

        case 'init'
            set(gca,'xlim',[1,options.Generations+1]);
            %set(gca,'xlim',[1,11]);
            plotRange = errorbar(generation,Y,L,U);
            set(plotRange,'Tag','gaplot1drange');
            title('Range of Population, Mean','interp','none')
            xlabel('Generation','interp','none')
        case 'iter'
            plotRange = findobj(get(gca,'Children'),'Tag','gaplot1drange');
            newX = [get(plotRange,'Xdata') generation];
            newY = [get(plotRange,'Ydata') Y];
            newL = [get(plotRange,'Ldata'); L];
            newU = [get(plotRange,'Udata'); U];
            if i%2 > 0
                set(findobj('Type','line'),'MarkerEdgeColor','r');
                set(findobj('Type','line'),'Marker','+');
            else
                set(findobj('Type','line'),'MarkerEdgeColor','k');
                set(findobj('Type','line'),'Marker','*');    
            end
            set(plotRange, 'Xdata',newX,'Ydata',newY,'Ldata',newL,'Udata',newU);
    end
end
