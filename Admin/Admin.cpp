#include "Admin.h"
#include <stdio.h> 
#include <time.h>
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <string>
#include <vector>
#include <algorithm>
#include <fstream>
#include <ctime>
#include <windows.h>
#include <process.h> 

int Admin::auction = 0;
int Admin::task = 0;

Admin::Admin(std::string _addr, int _type): Node(_addr, _type)
{
	setup();
	r = 0;
	while(r<RUNS)
	{
		add_tasks();
		send_auctions();
		get_winners();
		schedule();
		r++;
	}
}

Admin::~Admin(){
}

void Admin::setup()
{
	std::string ip;
	std::ifstream ifs("network.txt", std::ifstream::in);
	if(ifs.is_open())
	{
		while(getline(ifs, ip))
			nodes.emplace_back(ip);
		ifs.close();
	}
	std::cout << "adding nodes" << std::endl;
	int temp = 0;
	std::string cur_seller;
	for(std::deque<std::string>::iterator it = nodes.begin(); it != nodes.end(); it++)
	{
		temp++;
		if((temp % GROUP_SIZE) == 1)
		{
			cur_seller = *it;
	                Poco::Thread* t = new Poco::Thread();
                	t->start(*this);
                	recv_threads.insert(std::make_pair(cur_seller, t));
                	std::string msg = "Activate " + std::to_string(this->getTLS());
                	sellers.insert(std::make_pair(cur_seller, this->getTLS()));
			std::cout << "activate seller" << std::endl;
                	send(cur_seller, PORT+1, msg);  
		}
		else
		{
			std::string msg = "Participant " + *it;
			std::cout << "adding participant" << std::endl;
			send(cur_seller, PORT+1, msg);
		}
			
	}
}

void Admin::add_tasks()
{
	std::string t;
	for(int i = 0; i < MAX_TASKS; i++){
		t = ((i%2)==0) ? "CPU" : "IO";
		this->tasks.insert(std::make_pair(task++, t));
		std::cout << "add task" << std::endl;
	}
}

void Admin::send_auctions()
{
	for(std::unordered_map<std::string, int>::iterator it = sellers.begin(); it != sellers.end(); it++)
	{
		for(std::unordered_map<int, std::string>::iterator t = tasks.begin(); t != tasks.end(); t++)
		{
			std::cout << "sending auctions" << std::endl;
                	send(it->first, PORT+1, std::to_string(t->first));
			auction++;
		}
	}
}

void Admin::get_winners()
{
	int i = 0, tid;
	double winbid;
	while(i < auction)
	{
		for(std::unordered_map<std::string, int>::iterator it = sellers.begin(); it != sellers.end(); it++)
		{
			std::unordered_map<std::string,std::deque<std::string>*>::iterator got = msgs.find(it->first);
        		if (got != msgs.end())
			{
				while(got->second->size() > 0)
				{
					std::string msg = got->second->front();
					got->second->pop_front();
					
	                        	std::istringstream iss(msg);
        	                	std::string token, win;
					std::vector<std::string> w;
                      			while(iss >> token) w.push_back(token);
					tid = std::stoi(w[0]);
					win = w[1];
					winbid = std::stod(w[2]);
					
					std::unordered_map<int, std::deque<std::string>*>::iterator w1 = winners.find(tid);
					std::unordered_map<int, std::deque<double>*>::iterator w2 =  winner_bids.find(tid);	
					if(w1 == winners.end())
						winners.insert(std::make_pair(tid, new std::deque<std::string>()));
					if(w2 == winner_bids.end())
						winner_bids.insert(std::make_pair(tid, new std::deque<double>()));
					
					w1->second->push_back(win); 
					w2->second->push_back(winbid);
					std::cout << "added winner" << std::endl;
					i++;
				}
			}
		}
	}
}

void Admin::schedule()
{
	for(int i = 0; i < MAX_TASKS; i++){
		std::cout << "scheduled" << std::endl;
	}
}

void Admin::genetic()
{}

void Admin::sim_anneal()
{
   typedef vector<double> Layer; //defines a vector type

   typedef struct {
      Layer Solution1;
      double temp1;
      double coolingrate1;
      int MCL1;
      int prob1;
   }t; 

   srand ( time(NULL) ); //seed for getting different numbers each time the prog is run
   Layer SearchSpace(50); //declare a vector of 20 dimensions
   for(int a = 0;a < 10; a++){
      for (int i = 0 ; i < SearchSpace.size(); i++)
         SearchSpace[i] = Rand_NormalDistri(5, 1);
   
      t *arg1 = new t;
      arg1->Solution1 = SearchSpace;
      arg1->temp1 = 1000;  
      arg1->coolingrate1 = 0.01;
      arg1->MCL1 = 100; 
      arg1->prob1 = 3;

      _beginthread( SA, 0, (void*) arg1);
      Sleep( 100 );
      SA(SearchSpace, 1000, 0.01, 100, 3);
   }
}

double  Rand_NormalDistri(double mean, double stddev) {
   //Random Number from Normal Distribution
   static double n2 = 0.0;
   static int n2_cached = 0;
   if (!n2_cached) {
      // choose a point x,y in the unit circle uniformly at random
      double x, y, r;
      do {
      //  scale two random integers to doubles between -1 and 1
         x = 2.0*rand()/RAND_MAX - 1;
         y = 2.0*rand()/RAND_MAX - 1;
         r = x*x + y*y;
      } while (r == 0.0 || r > 1.0);

      // Apply Box-Muller transform on x, y
      double d = sqrt(-2.0*log(r)/r);
      double n1 = x*d;
      n2 = y*d;

      // scale and translate to get desired mean and standard deviation
      double result = n1*stddev + mean;
      n2_cached = 1;
      return result;    
   } 
   else {
      n2_cached = 0;
      return n2*stddev + mean;
   }
}

double   FitnessFunc(Layer x, int ProbNum)
{
   int i,j,k;
   double z; 
   double fit = 0;  
   double   sumSCH; 

   if(ProbNum==1){
   // Ellipsoidal function
      for(j=0;j< x.size();j++)
         fit+=((j+1)*(x[j]*x[j]));
   }
   else if(ProbNum==2){
   // Schwefel's function
      for(j=0; j< x.size(); j++)
      {
         sumSCH=0;
         for(i=0; i<j; i++)
            sumSCH += x[i];
         fit += sumSCH * sumSCH;
      }
   }
   else if(ProbNum==3){
   // Rosenbrock's function
      for(j=0; j< x.size()-1; j++)
         fit += 100.0*(x[j]*x[j] - x[j+1])*(x[j]*x[j] - x[j+1]) + (x[j]-1.0)*(x[j]-1.0);
   }
return fit;
}

double probl(double energychange, double temp){
    double a;
    a= (-energychange)/temp;
    return double(min(1.0,exp(a)));
}

int random (int min, int max){
    int n = max - min + 1;
    int remainder = RAND_MAX % n;
    int x;
    do{
      x = rand();
    }while (x >= RAND_MAX - remainder);
    return min + x % n;
}

//void SA(Layer Solution, double temp, double coolingrate, int MCL, int prob){
void SA(void *param){

    t *args = (t*) param;

    Layer Solution = args->Solution1;
    double temp = args->temp1;
    double coolingrate = args->coolingrate1;
    int MCL = args->MCL1;
    int prob = args->prob1;

    double Energy;
    double EnergyNew;
    double EnergyChange;
    Layer SolutionNew(50);

    Energy = FitnessFunc(Solution, prob);

    while (temp > 0.01){

        for ( int i = 0; i < MCL; i++){
            for (int j = 0 ; j < SolutionNew.size(); j++){

                SolutionNew[j] = Rand_NormalDistri(5, 1);
            }
            EnergyNew = FitnessFunc(SolutionNew, prob);
            EnergyChange = EnergyNew - Energy;

            if(EnergyChange <= 0){
                Solution = SolutionNew;
                 Energy = EnergyNew;    
            }
            if(probl(EnergyChange ,temp ) >  random(0,1)){
                //cout<<SolutionNew[i]<<endl;
                Solution = SolutionNew;
                 Energy = EnergyNew;
                cout << temp << "=" << Energy << endl;
            }
        }
        temp = temp * coolingrate;
    }
}
