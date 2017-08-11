#include <string>;
#include <stdio.h>;
using namespace std;

int start_old=200, end_old=201;

int start_new=400;
int main(){
for(int i = start_old; i < end_old; i++){
	string str_old = to_string(i);
	string  str_new = to_string(start_new+i);

	rename((str_old + "pop.txt").c_str(), (str_new + "pop.txt").c_str());
	rename((str_old + "mat.txt").c_str(), (str_new + "mat.txt").c_str());
	rename((str_old + "seppop.txt").c_str(), (str_new + "seppop.txt").c_str());
	rename((str_old + "species_fast.txt").c_str(), (str_new + "species_fast.txt").c_str());
	
	// rename(str_old + "species_fast.txt", str_new + "species_fast.txt");
}
}