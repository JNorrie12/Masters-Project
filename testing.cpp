#include "Tana+.hpp"
using namespace std;

mt19937 eng(12345);
// }
// const int genomes = 5;
// int Weightedrandom( array<int,genomes> choice_weight, int num_choices);
// void Wieghtedrandom(array<int,genomes> &spec, array<int,genomes> &seccum){
//     int cumulative = 0 ;

//     for (int  i=0; i<genomes; i++){
//         cumulative += spec[i];
//         seccum[i] =  cumulative;
//     }
//     // random = choose_in_range(0, specie
const int genomes=5 ;

int choose_in_range(int a, int b){
    uniform_int_distribution<> choose(a, b); // define the range [a,b], extremes included.
    return choose(eng);
}

int Weightedrandom(array<int, genomes> &spec, vector <int> &ex, int &pop){
int rnd = choose_in_range(0, pop-1);
int sum = pop;
for(int j=0; j< ex.size(); j++){
	int index=ex[j];
	sum -= spec[index];
	if(rnd > sum){
		return j;
	}
}
cout << "NO" << endl;
}


int main(){
	array<int,genomes> species={1,2,3,0,5};
// 	int x;
// 	// array <int, genomes> c;
// 	for(int i=0 ; i<10; i++){
// 		x = Weightedrandom(species, genomes);
	
// 	cout << x << endl;
// 	}
// }