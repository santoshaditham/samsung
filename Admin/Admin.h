#include <iostream>
#include <fstream>
#include <sstream>
#include <deque>
#include <unordered_map>
#include <string>
#include "Node.h"
#include "Poco/ThreadLocal.h"

#define RUNS 100
#define MAX_TASKS 10
#define GROUP_SIZE 5

class Admin: public Node{
private:
int r;
std::deque<std::string> nodes;
std::unordered_map<int, std::string> tasks;
std::unordered_map<int, std::deque<std::string>*> winners;
std::unordered_map<int, std::deque<double>*> winner_bids;
std::unordered_map<std::string, int> sellers;
std::unordered_map<std::string, Poco::Thread*> recv_threads;

public:
static int auction, task;
Admin(std::string, int);
~Admin();

void setup();
void add_tasks();
void send_auctions();
void get_winners();

void schedule();
void genetic();
void sim_anneal();

};
