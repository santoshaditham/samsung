% Travelling Sales man problem using Tabu Search 
% This assumes the distance matrix is symmetric 
% Tour always starts from node 1 
% **********Read distance (cost) matrix from Excel sheet "data.xls"****** 
clc
filename = 'auction_winners.data';
winners = csvread(filename);
filename = 'auction_bids.data';
bids = csvread(filename);

d_orig = d; 
start_time = cputime; 
dim1 = size(d,1); 
dim12 = size(d); 
for i=1:dim1 
   d(i,i)=10e+06; 
end 

% *****************Initialise all parameters********************** 
d1=d; 
tour = zeros(dim12); 
cost = 0; 
min_dist=[ ]; 
short_path=[ ]; 
best_nbr_cost = 0; 
best_nbr = [ ]; 

% *******Generate Initial solution - find shortest path from each node**** 
% if node pair 1-2 is selected, make distance from 2 to each of earlier 
%visited nodes very high to avoid a subtour 
k = 1; 
for i=1:dim1-1 
   min_dist(i) = min(d1(k,:)); 
   short_path(i) = find((d1(k,:)==min_dist(i)),1); 
   cost = cost+min_dist(i); 
   k = short_path(i); 
   % prohibit all paths from current visited node to all earlier visited nodes 
   d1(k,1)=10e+06; 
   for visited_node = 1:length(short_path); 
        d1(k,short_path(visited_node))=10e+06; 
   end 
end 
tour(1,short_path(1))=1; 
for i=2:dim1-1 
   tour(short_path(i-1),short_path(i))=1; 
end 
%Last visited node is k; 
%shortest path from last visited node is always 1, where the tour 
%originally started from 
last_indx = length(short_path)+1; 
short_path(last_indx)=1; 
tour(k,short_path(last_indx))=1; 
cost = cost+d(k,1); 

% A tour is represented as a sequence of nodes startig from second node (as 
% node 1 is always fixed to be 1 
crnt_tour = short_path; 
best_tour = short_path; 
best_obj =cost; 
crnt_tour_cost = cost; 
fprintf('\nInitial solution\n'); 
crnt_tour; 
fprintf('\nInitial tour cost = %d\t', crnt_tour_cost); 
nbr_cost=[ ]; 

% Initialize Tabu List "tabu_tenure" giving the number of iterations for 
% which a particular pair of nodes are forbidden from exchange 
tabu_tenure = zeros(dim12); 
max_tabu_tenure = round(sqrt(dim1)); 
%max_tabu_tenure = dim1; 
penalty = zeros(1,(dim1-1)*(dim1-2)/2); 
frequency = zeros(dim12); 
frequency(1,:)=100000; 
frequency(:,1)=100000; 
for i=1:dim1 
   frequency(i,i)=100000; 
end 
iter_snc_last_imprv = 0; 

%*********Perform the iteration until one of the criteria is met*********** 
%1. Max number of iterations reached*************************************** 
%2. Iterations since last improvement in the best objective found so far 
% reaches a threshold****************************************************** 
best_nbr = crnt_tour; 
for iter=1:10000 
   fprintf('\n*****iteration number = %d*****\n', iter); 
   nbr =[]; 
  % *******************Find all neighbours to current tour by an exchange 
  %******************between each pair of nodes*********************** 
  % ****Calculate the object value (cost) for each of the neighbours****** 
   nbr_cost = inf(dim12); 
   for i=1:dim1-2 
     for j=i+1:dim1-1 
       if i==1 
          if j-i==1 
            nbr_cost(crnt_tour(i),crnt_tour(j))=crnt_tour_cost-d(1,crnt_tour(i))+d(1,crnt_tour(j))-d(crnt_tour(j),crnt_tour(j+1))+d(crnt_tour(i),crnt_tour(j+1)); 
            best_i=i; 
            best_j=j; 
            best_nbr_cost = nbr_cost(crnt_tour(i),crnt_tour(j)); 
            tabu_node1 = crnt_tour(i); 
            tabu_node2 = crnt_tour(j);
          else 
            nbr_cost(crnt_tour(i),crnt_tour(j))=crnt_tour_cost-d(1,crnt_tour(i))+d(1,crnt_tour(j))-d(crnt_tour(j),crnt_tour(j+1))+d(crnt_tour(i),crnt_tour(j+1))-d(crnt_tour(i),crnt_tour(i+1))+d(crnt_tour(j),crnt_tour(i+1))-d(crnt_tour(j-1),crnt_tour(j))+d(crnt_tour(j-1),crnt_tour(i)); 
          end 
       else 
          if j-i==1 
            nbr_cost(crnt_tour(i),crnt_tour(j))=crnt_tour_cost-d(crnt_tour(i-1),crnt_tour(i))+d(crnt_tour(i-1),crnt_tour(j))-d(crnt_tour(j),crnt_tour(j+1))+d(crnt_tour(i),crnt_tour(j+1)); 
          else 
            nbr_cost(crnt_tour(i),crnt_tour(j))=crnt_tour_cost-d(crnt_tour(i-1),crnt_tour(i))+d(crnt_tour(i-1),crnt_tour(j))-d(crnt_tour(j),crnt_tour(j+1))+d(crnt_tour(i),crnt_tour(j+1))-d(crnt_tour(i),crnt_tour(i+1))+d(crnt_tour(j),crnt_tour(i+1))-d(crnt_tour(j-1),crnt_tour(j))+d(crnt_tour(j-1),crnt_tour(i)); 
          end 
       end 
       if nbr_cost(crnt_tour(i),crnt_tour(j)) < best_nbr_cost 
            best_nbr_cost = nbr_cost(crnt_tour(i),crnt_tour(j)); 
            best_i=i; 
            best_j=j; 
            tabu_node1 = crnt_tour(i); 
            tabu_node2 = crnt_tour(j); 
       end 
     end 
   end 

 %*********** Neighbourhood cost calculation ends here*********** 
 best_nbr(best_i) = crnt_tour(best_j); 
 best_nbr(best_j) = crnt_tour(best_i); 

 %****Replace current solution by the best neighbour.******************* 
 %**************Enter it in TABU List ****************** 
 %***Label tabu nodes such that tabu node2 is always greater than tabu 
 %node1. This is required to keep recency based and frequency based tabu 
 %list in the same data structure. Recency based list is in the space 
 %above the main diagonal of the Tabu Tenure matrix and frequency based 
 %tabu list is in the space below the main diagonal****************** 
 %******Find the best neighbour that does not involve swaps in Tabu List*** 
 %*************** OVERRIDE TABU IF ASPIRATION CRITERIA MET************** 
 %**************Aspiration criteria is met if a Tabu member is better 
 %than the best solution found so far********************************** 
 %while (tabu_tenure(tabu_node1,tabu_node2)|tabu_tenure(tabu_node2,tabu_node1))>0 
 while (tabu_tenure(tabu_node1,tabu_node2))>0 
   if best_nbr_cost < best_obj      %(TABU solution better than the best found so far) 
         fprintf('\nbest nbr cost = %d\t and best obj = %d\n, hence breaking',best_nbr_cost, best_obj); 
     break; 
   else 
     %***********Make the cost of TABU move prohibitively high to 
     %***disallow its selection and look for the next best neighbour 
     %****that is not TABU Active**************************** 
     nbr_cost(tabu_node1,tabu_node2)=nbr_cost(tabu_node1,tabu_node2)*1000; 
     best_nbr_cost_col = min(nbr_cost); 
     best_nbr_cost = min(best_nbr_cost_col); 
     [R,C] = find((nbr_cost==best_nbr_cost),1); 
     tabu_node1 = R; 
     tabu_node2 = C; 
   end 
 end 

%********Continuous diversification when best nbr cost gt crnt********* 
%*******tour cost by penalising objective by frequency of moves******** 
if best_nbr_cost > crnt_tour_cost 
   fprintf('\nbest neighbor cost greater than current tour cost\n'); 
   min_d_col = min(d); 
   penal_nbr_cost = nbr_cost + min(min_d_col)*frequency; 
   penal_best_nbr_cost_col = min(penal_nbr_cost); 
   penal_best_nbr_cost = min(penal_best_nbr_cost_col); 
   [Rp,Cp] = find((penal_nbr_cost==penal_best_nbr_cost),1); 
   tabu_node1 = Rp; 
   tabu_node2 = Cp; 
   best_nbr_cost = nbr_cost(tabu_node1,tabu_node2); 
end 

% *******************Decrease all Tabu Tenures by 1******************** 
for row = 1:dim1-1 
   for col = row+1:dim1 
     if tabu_tenure(row,col)>0 
        tabu_tenure(row,col)=tabu_tenure(row,col)-1; 
        tabu_tenure(col,row)=tabu_tenure(row,col); 
     end 
   end 
end 

%**********************RECENCY TABU***************************** 
%Enter current moves in Tabu List with tenure = maximum tenure** 
tabu_tenure(tabu_node1,tabu_node2)= max_tabu_tenure; 
tabu_tenure(tabu_node2,tabu_node1)= tabu_tenure(tabu_node1,tabu_node2); 

%**********************FREQUENCY TABU***************************** 
%Increase the frequency of current moves in Tabu List by 1******** 
%tabu_tenure(tabu_node2,tabu_node1)=tabu_tenure(tabu_node2,tabu_node1)+1; 
frequency(tabu_node1,tabu_node2)= frequency(tabu_node1,tabu_node2)+1; 

%********Update current tour************** 
crnt_tour=best_nbr; 
crnt_tour_cost=best_nbr_cost; 

%************Update best tour******************* 
if crnt_tour_cost < best_obj 
   best_obj= crnt_tour_cost; 
   best_tour= crnt_tour; 
   iter_snc_last_imprv= 0; 
else 
   iter_snc_last_imprv = iter_snc_last_imprv + 1; 
   %if iter_snc_last_imprv >= (dim1-1)*(dim1-2)/2 
   if iter_snc_last_imprv >= 400 
     fprintf('\n NO improvmennt since last % iterations, hence diversify\n',iter_snc_last_imprv); 
     min_freq_col = min(frequency);    %gives minimum of each column 
     min_freq = min(min_freq_col); 
     [R,C] = find((frequency==min_freq),1);  %find the moves with lowest frequency 
     freq_indx1 = R 
     freq_indx2 = C 
     indx_in_crnt_tour1 = find(crnt_tour==R); %locate the moves in the crnt tour 
     indx_in_crnt_tour2 = find(crnt_tour==C); 
     %Diversify using a move that has the lowest frequency 
     temp = crnt_tour(indx_in_crnt_tour1); 
     crnt_tour(indx_in_crnt_tour1) = crnt_tour(indx_in_crnt_tour2); 
     crnt_tour(indx_in_crnt_tour2) = temp; 
     tabu_tenure = zeros(dim12);  
     frequency = zeros(dim12); 
     frequency(1,:)=100000; 
     frequency(:,1)=100000; 
     for i=1:dim1 
         frequency(i,i)=100000; 
     end 
     tabu_tenure(R,C)=max_tabu_tenure; 
     tabu_tenure(C,R)=max_tabu_tenure; 
     frequency(R,C)=frequency(R,C)+1; 
     frequency(C,R) = frequency(R,C); 
     %Re-calculare crnt tour cost 
     crnt_tour_cost = d(1,crnt_tour(1)); 
     for i=1:dim1-1 
           crnt_tour_cost = crnt_tour_cost+d(crnt_tour(i),crnt_tour(i+1)); 
     end 
     iter_snc_last_imprv = 0; 
     if crnt_tour_cost < best_obj 
        best_obj = crnt_tour_cost; 
        best_tour = crnt_tour; 
     end 
   end 
end 
   fprintf('\ncurrent tour cost = %d\t', crnt_tour_cost); 
   fprintf('best obj =%d\t',best_obj); 
end 

fprintf('\nbest tour\n'); 
best_tour; 
fprintf('best obj =%d\n',best_obj); 
end_time = cputime; 
exec_time = end_time - start_time; 
fprintf('\ntime taken = %f\t', exec_time); 