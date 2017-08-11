
#include "Tana+.hpp";
#include <string> ;
using namespace std;
random_device rd;
mt19937 eng(rd());

// const int L1=1, genomes1=2 , L2=1, genomes2=2, No1=1000, No2=1000, K=1, generations = 10000;
// const double theta = 1, pmut = 0.005, pkill = 0.1, c = 2, mu = 0.007;

// const int L1=8, genomes1=256 , L2=8, genomes2=256, No1=1000, No2=1000, K=1, generations = 10000;
// const double theta = .25, pmut = 0.005, pkill = 0.1, c = 2, mu = 0.007;

const int L1=8, genomes1=256 , L2=8, genomes2=256, No1=1000, No2=1000, K=1, generations = 10000;
const double theta = .25, pmut = 0.005, pkill = 0.2, c = 0, mu = 0.007;
//====================================================================================
// const int L1=8, genomes1=256 , L2=8, genomes2=256, No1=1000, No2=1000, K=1, generations = 10000;
// const double theta = .25, pmut = 0.005, pkill = 0.2, c = 1.3, mu = 0.007;
//===================================================================================

// const int L1=8, genomes1=256 , L2=8, genomes2=256, No1=1000, No2=1000, K=1, generations = 10000;
// const double theta = .25, pmut = 0.005, pkill = 0.05, c = 10, mu = 0.007;

const double pi = 3.1415927;
const int genomes= genomes1+ genomes2; 
int choose_in_range(int a, int b);

//---------------------------------------
template <class T> //class basically just means a generic type of data, i.e int or char...
T set_species (T &vec) {
    for (int i=0; i < vec.size(); i++) {
        vec[i]=0;
    }

    // int select1 = choose_in_range(0,genomes1-1);
    // int select2 = choose_in_range(genomes1, genomes-1);

    // vec[select1] += No1;
    // vec[select2] += No2; 
    int select;
    for (int i=0; i < No1; i++) {
        select = choose_in_range(0,genomes1-1);
        vec[select] += 1;
    }
    for(int j=0; j < No2; j++){
        select = choose_in_range(genomes1, genomes-1);
        vec[select] += 1;
    }
    return (vec);
}

//----------------------------------------------
int choose_in_range(int a, int b){
    uniform_int_distribution<> choose(a, b); // define the range [a,b], extremes included.
    return choose(eng);
}


//-----------CREATING J-------------------------

double uniform(int a, int b){
    uniform_real_distribution<> rand(a, b); // define the range [a,b], extremes included.
    return rand(eng);
}

void Create_J(double (&J)[genomes][genomes]){
    
    for(int i=0; i < genomes; i++){
        
        for(int j=0; j < i; j++){
            if((i>=genomes1 && j<genomes1) || (i<genomes1 && j>=genomes1)){
                if(uniform(0,1)<= theta){

                    J[i][j]=uniform(-1, 1);
                    J[j][i]=uniform(-1, 1);
            }

            }
        }
    }
}
//----------------------------------------

void Kill (array<int,genomes> &spec, vector<int> &ex, int &N1, int &N2){
    int chosen, selected;
    // select an element of existent.
    selected = choose_in_range(0, ex.size() - 1);
    // associate the correspondent species.
    chosen = ex[selected];
    // Attempt to kill an individual.
    if (uniform(0, 1) <= pkill) {
        // total population decreases by 1.
        spec[chosen] -=1;
        if (chosen < genomes1){
            N1--;
        }
        else{
            N2--;
        }
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


void Baby(array<int,genomes> &spec ,vector<int> &ex, double (&J)[genomes][genomes], int &N1, int &N2) {

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
    if(chosen < genomes1){
        H = (c*t1)/N2 - mu*N1;
    } else {
        H = (c*t1)/N1 - mu*N2;
    }

    poff = 1/(1+exp(-H));
    // try to reproduce a species.
    
    if (uniform(0, 1) <= poff){
        //total population increases by 1.
        // Kill the parent.
        spec[chosen] -= 1;

        // check if it implies extinction.
        if (spec[chosen] == 0) {
            ex.erase (ex.begin() + selected);
        }
        if(chosen < genomes1){
        // c is dummy variable so we can create arrays in if statements
           	int c1[L1];
           	b1.insert(b1.begin(), c1, c1 + L2);
            ConvertToBinary(chosen, L1, b1);
        	
        	//Necessary for next for loop
        	L = L1;

            N1++;
        }
        else{
            int c1[L2];
            b1.insert(b1.begin(), c1, c1 + L2);
            ConvertToBinary(chosen-genomes1, L2, b1);
        	
       		L = L2;

            N2++;
        }
        
        b2 = b1;
        
        // Apply mutations to babies.
        for (i=0; i<L; i++) {
            // 1st baby.
            if (uniform(0,1 ) <= pmut) {
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
        //############################################
        s1 = ConvertToDec(b1);
        s2 = ConvertToDec(b2);
        if(chosen >= genomes1){
            s1 += genomes1;
            s2 += genomes1;
        }
        // if((((s1 < genomes1)||(s2 < genomes1)) && chosen >= genomes1 ) || (((s1 >= genomes1)||(s2 >= genomes1)) && chosen < genomes1 )){
            // cout << "POPULATION ERROR" << endl;
        // }
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
    // if(N != N1 + N2){
    //     cout << "POPULATION ERROR" << endl;
    // }    
}

int Tstart = 101 , T = 200;

//----------------------------------------
int main(){
    for(int k = Tstart; k < Tstart+T; k++){
        
        array <int, genomes> species;
        set_species(species);
        
        
        double J[genomes][genomes]={}; //creates 0 vector
        // double J[genomes][genomes]={{0,0, 0.5, 0},{0,0,0.52,0},{0.7,0.4,0},{0,0,0,0}};
    	Create_J(J);

        vector <int> existent;
        int i, N1, N2, count_gen, step;

        N1=No1, N2=No2;

        double tau;
        tau = round(double(N1 + N2)/pkill);

        for(i=0; i<genomes; i++){
            if (species[i] != 0){
                existent.push_back(i);
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

        ofstream spec;
        spec.open(str +"species_fast.txt");
        for(int i=0; i<genomes; i++){
            spec << 0 << "\t" ;
        }
        spec << endl;

        ofstream pop;
        pop.open(str + "pop.txt");
        ofstream seppop;
        seppop.open(str + "seppop.txt");
        // ofstream Hpoff;
        // Hpoff.open(str + "Hpoff.txt");

        count_gen = 0;
        step = 0;
        while( count_gen < generations){
            step++;
            //KILL FUNCTION
            Kill(species, existent, N1, N2);
            //BABY FUNCTION
            Baby(species, existent, J, N1, N2);
            
            // cout << "WHAT" << endl;
            if(step == tau){
                count_gen++;
                step=0;
                tau = round(double(N1+N2)/pkill);

                if(N1==0 || N2==0){
                    cout << "extinction" << endl;
                    // exit(EXIT_FAILURE);
                }
                if(N1==0 && N2==0){
                    exit(EXIT_FAILURE);
                }
                pop << count_gen << "\t" <<N1 << "\t" << N2 << "\t" << N1 + N2 <<endl;

                seppop << count_gen;
                for(i=0; i<genomes; i++){
                seppop << "\t" << species[i]; 
                }
                seppop << endl;

                // Hpoff << H << "\t" << poff <<endl;
                // mydata << count_gen << "\t" << N << endl;
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
        spec.close();            
        pop.close();
        seppop.close();
        cout << k << endl;
    }
}