#include <iostream>
#include "Seller.h"
#define SELLER_ADDR "127.0.0.1"

int main(){
	Seller *s = new Seller(SELLER_ADDR, 1);
	delete(s);
	return 0;
}
