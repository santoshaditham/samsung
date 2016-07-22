#include <iostream>
#include "Participant.h"
#define PARTICIPANT_ADDR "127.0.0.1"

int main(){
	Participant *p = new Participant(PARTICIPANT_ADDR, 2);
	delete(p);
	return 0;
}
