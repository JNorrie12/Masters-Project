
#include "Tana+.hpp" // Include all libraries.
using namespace std;
random_device rd; // obtain a random number from hardware.
mt19937 eng(rd()); // seed the generator.

// void posneg(){
//   //   bool x;
//   // bernoulli_distribution(0.5);
//     if(x== 0){
//         x=-1;
//     }
//     return bernoulli_distribution(0.5);
// }
int posneg(){
	double p = 0.5;
	double r = ((double) rand() / (RAND_MAX));
	unsigned int br = -1;
	if (r >= p) {
		br = 1;
	}
	return br;
}


int main(){
	for(int i=0; i<10; i++){
	int x;
	x= posneg();

	cout<< x << endl;
	}
}
