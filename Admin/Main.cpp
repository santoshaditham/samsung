#include <iostream>
#include "Admin.h"
#define ADMIN_ADDR "127.0.0.1"

int main(){
	Admin *a = new Admin(ADMIN_ADDR, 0);
	std::cout << "DONE!";
	delete a;	
	return 0;
}
