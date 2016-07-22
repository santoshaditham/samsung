#include <string>
#include <map>

class Auction{
private:
int id;
int taskno;
std::string seller;
std::map<std::string, double> bids;
double winner_bid, tempbid;
std::string winner, temp;

public:
Auction(int, std::string);
~Auction();

void add_bid(std::string, double);
std::string get_winner();
double get_winner_bid();
int get_id();
int get_taskno();
};
