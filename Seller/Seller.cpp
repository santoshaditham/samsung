#include "Seller.h"

Seller::Seller(std::string _addr, int _type): Node(_addr,_type){
	recv_admin();
	recv_bids();
	conduct_auctions();
}

Seller::~Seller(){
}

void Seller::recv_admin(){
	int tasks = 0;
	while(tasks < TASKS){
		if(mutex.tryLock()){
		std::unordered_map<std::string,std::deque<std::string>*>::iterator got = msgs.find(ADMIN_ADDR);
		mutex.unlock();
        	if (got != msgs.end()){
		while(got->second->size()>0){
			std::string msg = got->second->front();
			std::cout << "recvd msg from admin" << std::endl;
			got->second->pop_front();
			std::istringstream iss(msg);
        		std::string token, temp;
        		while(getline(iss, token, ' ')){
				if(token == "Participant" || token == "Auction" || token == "Activate")
					temp = token;
			}
			if(temp == "Activate")
				this->admin_port = std::stoi(token);
			if(temp == "Participant")
				add_participant(token);
			if(temp == "Auction"){
				add_auction(std::stoi(token));
				tasks++;
			}
   		}
		}
	}
	}
}

void Seller::send_admin(std::string _msg){
	std::cout << "sending msg to admin" << std::endl;
	send(ADMIN_ADDR, this->admin_port, _msg);
}

void Seller::add_participant(std::string _p){
        Poco::Thread *t = new Poco::Thread();
        t->start(*this);
        recv_threads.insert(std::make_pair(_p, t));
	participants.insert(std::make_pair(_p, this->getTLS()));
	std::cout <<"adding participant" << std::endl;
	std::string msg = "Seller " + std::to_string(this->getTLS()); 
	send(_p, PORT+1, msg);
}

void Seller::add_auction(int _taskno){
	Auction *a = new Auction(_taskno, this->address);
	auctions.insert(std::make_pair(a->get_id(), a));
	std::cout << "adding auction" << std::endl;
	send_auction_invites(a->get_id());
}

void Seller::send_auction_invites(int _aucid){
	std::string msg = "Auction " + std::to_string(_aucid);
	for (std::unordered_map<std::string, int>::iterator p = participants.begin(); p != participants.end(); ++p)
		send(p->first, PORT+1, msg);
}

void Seller::recv_bids(){
	unsigned int i=0;
	while(i < (auctions.size() * participants.size())){
	std::cout << "recvng bids" << std::endl;
		for (std::unordered_map<std::string,int>::iterator x = participants.begin(); x != participants.end(); ++x){
			std::unordered_map<std::string,std::deque<std::string>*>::iterator got = msgs.find(x->first);
        		if (got != msgs.end()){
                		if(got->second->size()>0){
					std::string msg = got->second->front();
					got->second->pop_front();
					std::istringstream iss(msg);
                        		std::string token;
					std::vector<std::string> t_msg;
					while (iss >> token) t_msg.push_back(token);
					std::string p = t_msg[0];
					int auc = std::stoi(t_msg[1]);
					double bid = std::stod(t_msg[2]);
					std::unordered_map<int, Auction*>::iterator it = auctions.find(auc);
					it->second->add_bid(p, bid);
					i++;	
				}
			}
		}
	}
}

void Seller::conduct_auctions(){
	for (std::unordered_map<int, Auction*>::iterator a = auctions.begin(); a != auctions.end(); ++a){
		winners.insert(std::make_pair(a->first, a->second->get_winner()));
		winners_bids.insert(std::make_pair(a->first, a->second->get_winner_bid()));
		std::string msg = std::to_string(a->second->get_taskno()) +" "+ a->second->get_winner() +" "+ std::to_string(a->second->get_winner_bid());
		send_admin(msg);
	}
}
