#include "Participant.h"

Participant::Participant(std::string _addr, int _type): Node(_addr, _type){
	recv_invite();
}

Participant::~Participant(){
}

void Participant::recv_invite(){
	std::unordered_map<std::string, std::deque<std::string>*>::iterator iter;
        std::deque<std::string> *invites;
	int tasks = 0;
	while(tasks < TASKS){
		std::cout << "recvng tasks" << std::endl;		
		if(mutex.tryLock()){
       	 		iter = msgs.begin();
			invites = iter->second;
        		mutex.unlock();
		}
		std::deque<std::string>::iterator it = invites->begin();
		while(it != invites->end()){
			std::istringstream iss(*it);
			std::string token, temp;
			while(getline(iss, token, ' '))
			{
      				if(token == "Seller" || token == "Auction")
					temp = token;
			}
			if(temp == "Seller"){
				std::string temp;
				std::vector<std::string> w;
				std::istringstream iss(token);
				while (iss >> temp) w.push_back(temp);  
				this->seller = w[0];
				this->seller_port = std::stoi(w[1]);
			}
			if(temp == "Auction"){
				auctions.push_back(std::stoi(token));
				tasks++;
				send_bid(std::stoi(token));
			}
		}
	}
}

void Participant::send_bid(int auc){
	calculate_bid();
	std::string msg = std::to_string(this->bid);
	std::cout << "sending bid" << std::endl;
	send(this->seller, this->seller_port, msg);
}

void Participant::calculate_bid(){
	std::string line, temp;
	std::vector<double> params;
	std::ifstream ipmifile ("ipmi.txt");
	if (ipmifile.is_open()){
    		while(getline(ipmifile, line)){
			std::istringstream iss(line);
                        while (iss >> temp){
				if(temp!="power" || temp!="voltage" || temp!="current"||
					temp!="memory" || temp!="loadAvg") 
					params.push_back(std::stod(temp));
			}
		}
	}
	this->bid = std::accumulate(params.begin(), params.end(), 0) / params.size();
}
