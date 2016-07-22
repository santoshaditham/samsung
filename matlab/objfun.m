function y = objfun( x )
 filename = 'auction_bids.data';
 bids = csvread(filename);
 filename = 'auction_winners.data';
 winners = csvread(filename);
 [p,q] = size(winners);
 bid_avg = zeros(q,q);
 for a=1:p,
     for b=1:q,
         bid_avg(b, winners(a,b)) = (bid_avg(b, winners(a,b)) + bids(a,b))/2;
     end
 end
 
intx= uint32(x);
c= size(intx,2);
y= 0;
[~,indx]=ismember(intx(1,:),winners,'rows');
if indx > 0
  y= sum(bids(indx,:));
else
  for j=1:c,
      y= y + bid_avg(j,intx(1,j));
  end    
end

end