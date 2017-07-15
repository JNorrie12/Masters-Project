#include "Tana+.hpp";
//DOUBLE

using namespace std;
random_device rd;
mt19937 eng(rd());

const int L1=1, genomes1=2 , L2=1, genomes2=2, No=1000, K=1, generations = 10000;
const double theta= 0, pmut = 0.5, pkill = 0.02, c = 10, mu = 0.005;
const double pi = 3.1415927;
const int genomes= genomes1+ genomes2; 
int choose_in_range(int a, int b);

//---------------------------------------
template <class T> //class basically just means a generic type of data, i.e int or char...
T set_species (T &vec) {
    for (int i=0; i < vec.size(); i++) {
        vec[i]=0;
    }

    int select;
    for (int i=0; i < No; i++) {
        select = choose_in_range(0,vec.size()-1);
        vec[select] += 1;
    }
    return (vec);
}

void Ngene(array <int, genomes> &arr, int N1, int N2){
	for (int i=0; i < genomes1; i++){
		N1 += arr[i];
	}
	for (int j=genomes1; j< genomes2; j++){
		N2 += arr[j];
	}
	cout << N1 << N2<< endl;
	// if(N1 ==0 || N2==0){
	// 	cout << "NO POPULATION" << endl;
	// }
}
//----------------------------------------------
int choose_in_range(int a, int b){
    uniform_int_distribution<> choose(a, b); // define the range [a,b], extremes included.
    return choose(eng);
}

//-----------CREATING J-------------------------

double uniform(void){
    uniform_real_distribution<> rand(0, 1); // define the range [a,b], extremes included.
    return rand(eng);
}

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
            if((i>=genomes1 && j<genomes1) || (i<genomes1 && j>=genomes1)){
                if(uniform()> theta){
                    int x, y;
                    x= posneg();
                    y=posneg();

                    J[i][j]=x*uniform();
                    J[j][i]=y*uniform();
            }

            }
        }
    }
}
//----------------------------------------

void Kill (array<int,genomes> &spec, vector<int> &ex, int &N){
    int chosen, selected;
    // select an element of existent.
    selected = choose_in_range(0, ex.size() - 1);
    // associate the correspondent species.
    chosen = ex[selected];
    // Attempt to kill an individual.
    if (uniform() <= pkill) {
        // total population decreases by 1.
        N--;
        spec[chosen] -=1;
        
        if (spec[chosen] == 0) {
            ex.erase(ex.begin() + selected);  // being "ex" small, is better than using std::list.
            }
        
    }
}

//------------------------------------------------------------
template<class U>
void Bin_recursive(int n, int j, U &vec){ // It must be called setting j=L.
    j--;
    if (n / 2 != 0) {
        Bin_recursive(n/2, j, vec);
    }
    vec[j] = n % 2;
}

template<class V>
void ConvertToBinary(int n, int j, V &vec){
    int i, L;
    L = vec.size();

    if(n >= pow(2,L)){
        cout << "the number cannot be represented" << endl;
        exit (EXIT_FAILURE);
    }
    for (i=0; i<L; i++) {
        vec[i]=0;
    }
    Bin_recursive(n, j, vec);
}

template<class W>
int ConvertToDec(W &arr){
    int i, dec=0, L;
    L= arr.size();

    for (i=0; i<L;i++) {
        if(arr[L-1-i] == 1){
            dec += pow(2,i);
        }
    }
    return dec;
}


void Baby(array<int,genomes> &spec ,vector<int> &ex, double (&J)[genomes][genomes], int &N) {

    int chosen, selected, add, i, s1, s2;
    double t1=0, H, poff;

    vector <int> b1, b2;
    int L;
    
    // select an element of existent.
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
    
    if (uniform() <= poff){
        //total population increases by 1.
        N++;
        // Kill the parent.
        spec[chosen] -= 1;

        // check if it implies extinction.
        if (spec[chosen] == 0) {
            ex.erase (ex.begin() + selected);
        }
        if(chosen < genomes1){
        // c is dummy variable so we can create arrays in if statements

           	int c[L1];
           	b1.insert(b1.begin(), c, c + L2);
            ConvertToBinary(chosen, L1, b1);
        	
        	//Necessary for next for loop
        	L =L1;
        }
        else{
            int c[L2];
            b1.insert(b1.begin(), c, c + L2);
            ConvertToBinary(chosen-genomes1, L2, b1);
        	
       		L = L2;
        }
        b2 = b1;
        
        // Apply mutations to babies.
        for (i=0; i<L; i++) {
            // 1st baby.
            if (uniform() <= pmut) {
                if (b1[i] == 1) {
                    b1[i]=0;
                } else {
                    b1[i]=1;
                }
            }
            // 2nd baby.
            if (uniform() <= pmut) {
                if (b2[i] == 1) {
                    b2[i]=0;
                } else {
                    b2[i]=1;
                }
            }
        }
        // Convert to decimal.
        //############################################
        s1 = ConvertToDec(b1);
        s2 = ConvertToDec(b2);

        if(chosen >= genomes1){
            s1 += genomes1;
            s2 += genomes1;
        }
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

//----------------------------------------
int main(){

    array <int, genomes> species;
    set_species(species);
    
    
    double J[genomes][genomes]={}; //creates 0 vector

	Create_J(J);

    vector <int> existent;
    int i, N, count_gen, step;

    N=No;
    int N1=0, N2=0;
    double tau;
    tau = round(double(N)/pkill);

    for(i=0; i<genomes; i++){
        if (species[i] != 0){
            existent.push_back(i);
        }
    }
    ofstream mydata;
    mydata.open("data_fast.txt");
    ofstream spec;
    spec.open("species_fast.txt");
    ofstream pop;
    pop.open("pop.txt");

    count_gen = 0;
    step = 0;

    while( count_gen < generations){
        step++;

        //KILL FUNCTION
        Kill(species, existent, N);
        //BABY FUNCTION
        Baby(species, existent, J, N);
        // cout << "WHAT" << endl;
        if(step == tau){
            count_gen++;
            step=0;
            tau = round(double(N)/pkill);
            
            N1=0, N2 =0;
            for (int i=0; i < genomes1; i++){
				N1 += species[i];
			}
				for (int j=genomes1; j< genomes2; j++){
				N2 += species[j];
			}
            if(N1==0 || N2==0){
                cout << "extinction" << endl;
                exit(EXIT_FAILURE);
            }
            pop << N1 << "\t" << N2 << endl;
            

            mydata << count_gen << "\t" << N << endl;
            // generation number --- population
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
}


