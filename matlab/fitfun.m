function fit = fitfun( x )
 filename = 'auction_bids.data';
 bids = csvread(filename);
 filename = 'auction_winners.data';
 winners = csvread(filename);
 [p,q] = size(winners);
 bid_avg = zeros(q,q);
 for a=1:p,
     for b=1:q,
         if(bids(a,b)==0)
            bid_avg(b, winners(a,b)) = (bid_avg(b, winners(a,b)) + max(bids(:)))/2; 
         else
            bid_avg(b, winners(a,b)) = (bid_avg(b, winners(a,b)) + bids(a,b))/2;
         end;
     end
 end
 winners = uint32(winners);
 c= size(x,2);
 for i=1:size(x,1),
    y= 0;
    [~,indx]=ismember(x(i,:),winners,'rows');
    if indx > 0
        y= sum(bids(indx,:));
    else
        for j=1:c,
            y= y + bid_avg(j,x(i,j));
        end 
    end;
    fit(i,1) = y;
 end;
end

