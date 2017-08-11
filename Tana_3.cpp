// g++ -std=c++11 Tana_fast.cpp




//WEIGHTED RANDOM CHOICES
//UNIFORM J



#include "Tana+.hpp" // Include all libraries.
using namespace std;
random_device rd; // obtain a random number from hardware.
mt19937 eng(rd()); // seed the generator.
// mt19937 eng(12345);
// mt19937 is Mersenne Twister pseudo-random generator of 32-bit numbers.

// -----------------------------------
//       INITIALIZE PARAMETERS
// -----------------------------------
// const int generations = 10000, L = 8, No = 1000, K = 1, genomes = 256;
// const double theta = .75, pmut = 0.025, pkill = 0.4, c = 40, mu = 0.007;

// const int generations = 10000, L = 9, No = 1000, K = 1, genomes = 512;
// const double theta = 0.75, pmut = 0.02, pkill = 0.25, c = 50, mu = 0.05;

const int generations = 10000, L = 9, No = 1000, K = 1, genomes = 512;
const double theta = 0.25, pmut = 0.005, pkill = 0.3, c = 10, mu = 0.005;

const double pi = 3.1415927;
// -----------------------------------
//        DECLARE FUNCTIONS
// -----------------------------------
double gaussian(void);
double uniform(int a, int b);
int choose_in_range(int a, int b);
void initial_pop( array<int, genomes> &vec);
void Kill (array<int,genomes> &spec, vector<int> &ex, int &N);
void Baby(array<int,genomes> &spec, vector<int> &ex, double (&J)[genomes][genomes], int &N);
void compute_interactions(int x, int y, array<double,genomes> &A, array <int, genomes> &B, array<double,2> &inter);
void Bin_recursive(int n, int j, array<int, L> &vec);
void ConvertToBinary(int n, int j, array<int, L> &vec);
int ConvertToDec(array<int, L> &arr);
void Create_J(double (&J)[genomes][genomes]);
int Weightedrandom(array<int, genomes> &spec, vector <int> &ex, int &pop);
// -----------------------------------
//            TEMPLATES
// -----------------------------------
template <class T>                      //Sets the genomes vector to 0 components
T zerovec (T &vec) {
    int i;
    for (i=0; i < vec.size(); i++) {
        vec[i]=0;
    }
    return (vec);
}

/* -----------------------------------
                  MAIN
   -----------------------------------
gemones-    Number of species
species-    Population of the indexed species, genomes=#ofspecies
existent-   List of existing species if 1,3 exist, existenet={1,3} 
N-          Moving total population 
tau-        Generation size 
*/
int Tstart = 1, T =100;

int main(){
    for(int k = Tstart; k < Tstart+T; k++){
        array <int, genomes> species;  //¬
        vector<int> existent;          
        int i,N, count_gen, step;
        double J[genomes][genomes]={};
        double tau;
        
        Create_J(J);
        // cout << J[4][4] << endl;
        for(int k=0; k<genomes; k++){
            for(int j=0; j < genomes; j++){
                cout << J[j][k] << "\t";
            }
            cout << endl;
        }
        // set all elements of species to zero and initialize population at random.
        zerovec(species); //¬
        initial_pop(species); //¬
        N = No;
        tau = round(double(N)/pkill);
        // Initialize a vector which contains the label of all existent species.
        
        for (i=0; i<genomes; i++) {
            if (species[i] != 0) {
                existent.push_back(i); //adds a new element at end of vector
            }
        }
        string str = to_string(k);
        
        ofstream mat;
        mat.open(str + "mat.txt");
        for(int i=0; i < genomes; i++){
            mat << J[i][0];
            for(int j=1; j < genomes; j++){
                mat << "\t" << J[i][j];
            }
            mat << endl;
        }
        mat.close();

        // create output files.
        ofstream mydata;
        mydata.open(str +"data_fast.txt");
        ofstream spec;
        spec.open(str + "species_fast.txt");
        ofstream seppop;
        seppop.open(str + "seppop.txt");
        
        count_gen = 0;
        step = 0;
        while (count_gen < generations) {
            step++;
            // Try to kill an individual.
            Kill(species, existent, N);
            // Try to reproduce an individual
            Baby(species, existent, J, N);
            if(step == tau){
                count_gen++;
                step=0;
                tau = round(double(N)/pkill);
                mydata << count_gen << "\t" << N << endl;
                // generation number --- population
                
                seppop << count_gen;
                for(i=0; i<genomes; i++){
                seppop << "\t" << species[i]; 
                }
                seppop << endl;


                for (i=0; i<existent.size(); i++) {
                    spec << existent[i] << "\t";
                }
                spec << endl;

                if (count_gen % (generations/10) == 0) {
                    cout << count_gen << endl;
                }
            }
        }
        mydata.close();
    spec.close();
    seppop.close();
    cout << k << endl;
    }
}

// -----------------------------------
//             FUNCTIONS
// -----------------------------------

void Baby(array<int,genomes> &spec, vector<int> &ex, double (&J)[genomes][genomes], int &N) {
    int chosen, selected, add, i, s1, s2;
    double t1=0, H, poff;
    array <int,L > b1, b2;
    
    // select an element of existent.
    // selected= Weightedrandom(spec, ex,  N);
    selected = choose_in_range(0, ex.size() - 1);
    // associate the correspondent species.
    chosen = ex[selected];
    // Compute poff
    for (i=0; i < ex.size(); i++) {
        t1 += J[chosen][ex[i]] * spec[ex[i]];
    }
    H = (c*t1)/N - mu*N; //H = c*t1/N - mu*N;
    poff = 1/(1+exp(-H));
    // try to reproduce a species.
    if (uniform(0, 1) <= poff){
        //total population increases by 1.
        N++;
        // Kill the parent.
        spec[chosen] -= 1;
        // check if it implies extinction.
        if (spec[chosen] == 0) {
            ex.erase (ex.begin() + selected);
        }
        ConvertToBinary(chosen, L, b1);
        b2 = b1;
        // Apply mutations to babies.
        for (i=0; i<L; i++) {
            // 1st baby.
            if (uniform(0, 1) <= pmut) {
                if (b1[i] == 1) {
                    b1[i]=0;
                } else {
                    b1[i]=1;
                }
            }
            // 2nd baby.
            if (uniform(0, 1) <= pmut) {
                if (b2[i] == 1) {
                    b2[i]=0;
                } else {
                    b2[i]=1;
                }
            }
        }
        // Convert to decimal.
        s1 = ConvertToDec(b1);
        s2 = ConvertToDec(b2);
        // Check if there are new species.
        add=0;
        for (i=0; i<genomes; i++) {
            if(spec[i]==0 && (s1==i || s2==i)){
                ex.push_back(i);
                add++;
            }
            if(add==1 && s1==s2){break;}
            if(add==2){break;}
        }
        // Add babies to species.
        spec[s1] += 1;
        spec[s2] += 1;
    }
}

//=================================================================

int posneg(){
    double p = 0.5;
    double r = ((double) rand() / (RAND_MAX));
    unsigned int br = -1;
    if (r >= p) {
        br = 1;
    }
    return br;
}

void Create_J(double (&J)[genomes][genomes]){
    
    for(int i=0; i < genomes; i++){
        
        for(int j=0; j < i; j++){

            if(uniform(0,1)> theta && i != j){

                J[i][j]=uniform(-1,1);
                J[j][i]=uniform(-1,1);

            }
        }
    }
}

int Weightedrandom(array<int, genomes> &spec, vector <int> &ex, int &pop){
int rnd = choose_in_range(0, pop-1);
// cout << rnd << endl;
int sum = pop;
for(int j=0; j< ex.size(); j++){
    int index=ex[j];
    sum -= spec[index];
    if(rnd >= sum){
        return j;
    }
}
cout << "NO" << endl;
}
//===================================================================
void Kill (array<int,genomes> &spec, vector<int> &ex, int &N){
    int chosen, selected;
    // select an element of existent.
    selected = choose_in_range(0, ex.size() - 1);
    // selected= Weightedrandom(spec, ex,  N);
    // associate the correspondent species.
    chosen = ex[selected];
    // Attempt to kill an individual.
    if (uniform(0,1) <= pkill) {
        // total population decreases by 1.
        N--;
        spec[chosen] -= 1;
        // Is the chosen species extinct?
        if (spec[chosen] == 0) {
            // ex.erase(ex.begin() + selected);  // being "ex" small, is better than using std::list.
            // for( int j=0; j<ex.size(); j++){
            //     if(ex[j] == chosen){
            //         ex.erase(ex.begin() + j);
            //     }
            // }
            ex.erase(ex.begin() + selected);
        }
    }
    // check if all species are dead.
    if (ex.size() == 0) {
        cout << "extinction" << endl;
        exit(EXIT_FAILURE);
    }
    // cout << "ccc" << endl;
}


void initial_pop( array<int, genomes> &vec){
    int i, select;
    for (i=1; i <= No; i++) {
        select = choose_in_range(0,genomes-1);
        vec[select] += 1;
    }
}
//Distributes population randomly across genomes


double uniform(int a, int b){
    uniform_real_distribution<> rand(a, b); // define the range [a,b], extremes included.
    return rand(eng);
}


int choose_in_range(int a, int b){
    uniform_int_distribution<> choose(a, b); // define the range [a,b], extremes included.
    return choose(eng);
}


void Bin_recursive(int n, int j, array<int, L> &vec){ // It must be called setting j=L.
    j--;
    if (n / 2 != 0) {
        Bin_recursive(n/2, j, vec);
    }
    vec[j] = n % 2;
}


void ConvertToBinary(int n, int j, array<int, L> &vec){
    int i;
    if(n >= pow(2,L)){
        cout << "the number cannot be represented" << endl;
        exit (EXIT_FAILURE);
    }
    for (i=0; i<L; i++) {
        vec[i]=0;
    }
    Bin_recursive(n, j, vec);
}


int ConvertToDec(array<int, L> &arr){
    int i, dec=0;
    for (i=0; i<L;i++) {
        if(arr[L-1-i] == 1){
            dec += pow(2,i);
        }
    }
    return dec;
}
