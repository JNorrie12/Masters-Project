//DisTana Model 
//
// Created by John Norrie

#include "Tana+.hpp"; //Including libraries.
#include <string> ;
using namespace std;
random_device rd; //obtain random number from hardware.
mt19937 eng(rd()); // seed the generator.
//--------------------------------------
//         INITIALIZE PARAMETERS
//--------------------------------------
const int L1=8, genomes1=256 , L2=8, genomes2=256, No1=1000, No2=1000, generations = 5000;
const double theta = .25, pmut = 0.005, pkill = 0.2, c = 0, mu = 0.007;
const double pi = 3.1415927;
const int genomes= genomes1+ genomes2; 

/*Trial Parameters:
Tstart = First trial number.
T = Number of trials to be ran.    */
int Tstart = 1, T = 1;

int choose_in_range(int a, int b);
//---------------------------------------
//         TEMPLATES
//---------------------------------------
template <class T> 
T set_species (T &vec) {
    for (int i=0; i < vec.size(); i++) {
        vec[i]=0;
    }
    int select; //Randomly add members to genespaces 1 & 2.
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

//---------------------------------------
//         FUNCTIONS
//---------------------------------------
int choose_in_range(int a, int b){  //Includes end values.
    uniform_int_distribution<> choose(a, b);
    return choose(eng);
}

double uniform(int a, int b){   //Includes end values.
    uniform_real_distribution<> rand(a, b);
    return rand(eng);
}

//Creating J matrix
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

//Kill Function
void Kill (array<int,genomes> &spec, vector<int> &ex, int &N1, int &N2){
    int chosen, selected;
    // select an element of existent.
    selected = choose_in_range(0, ex.size() - 1);
    // associate the correspondent species.
    chosen = ex[selected];
    // Attempt to kill an individual.
    if (uniform(0, 1) <= pkill) {
        // Species population decrease by one.
        spec[chosen] -=1;
        // Genespace population decrease by one.
        if (chosen < genomes1){
            N1--;
        }
        else{
            N2--;
        }
        //Remove from existent list.
        if (spec[chosen] == 0) {   
            ex.erase(ex.begin() + selected);  
            }      
    }
}

//Reproduction Function
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
        // Kill the parent.
        spec[chosen] -= 1;
        // check if it implies extinction.
        if (spec[chosen] == 0) {
            ex.erase (ex.begin() + selected);
        }
        //Increase Genespace population
        if(chosen < genomes1){
            int c1[L1];     //dummy variable
            b1.insert(b1.begin(), c1, c1 + L2);
            ConvertToBinary(chosen, L1, b1);
            L = L1; //dummy variable

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
//              SCRIPT
//----------------------------------------
int main(){
    int extinctions = 0;
    for(int k = Tstart; k < Tstart+T; k++){
        array <int, genomes> species;
        double J[genomes][genomes]={}; 
        int i, N1, N2, count_gen, step;
        vector <int> existent;
        double tau;
        //Create J.
    	Create_J(J);
        //Initialise populations.
        set_species(species);
        N1=No1, N2=No2;
        //Number of timesteps per generation.
        tau = round(double(N1 + N2)/pkill);
        //Initialise vector of existent species(basse 10 labels).
        for(i=0; i<genomes; i++){
            if (species[i] != 0){
                existent.push_back(i);
            }
        }
        //Create text files.
        string str = to_string(k);
        ofstream mat; //Text file of J.
        mat.open(str + "mat.txt"); 
        for(int i=0; i < genomes; i++){
            mat << J[i][0];
            for(int j=1; j < genomes; j++){
                mat << "\t" << J[i][j];
            }
            mat << endl;
        }
        mat.close();

        ofstream spec; //Text file for existent species.
        spec.open(str +"species_fast.txt");
        //Initialising size of array, necessary for Matlab  function importdata().
        for(int i=0; i<genomes; i++){
            spec << 0 << "\t" ;
        }
        spec << endl;

        ofstream pop; //Text file for genespace populations.
        pop.open(str + "pop.txt");
       
        ofstream seppop; //Text file for individual populations.
        seppop.open(str + "seppop.txt");

        count_gen = 0;
        step = 0;
        while( count_gen < generations){
            step++;
            //Kill attempt.
            Kill(species, existent, N1, N2);
            //Reproduction attempt.
            Baby(species, existent, J, N1, N2);
            
            if(step == tau){
                count_gen++;
                step=0;
                //Recalculate generation size.
                tau = round(double(N1+N2)/pkill);
                //extinction detection
                if(N1==0 || N2==0){
                    cout << "extinction" << endl;
                    extinctions++;
                    count_gen = generations + 1;
                }
                pop << count_gen << "\t" <<N1 << "\t" << N2 << "\t" << N1 + N2 <<endl;

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
        spec.close();            
        pop.close();
        seppop.close();
        cout << extinctions << "in" << k << endl;
    }
cout << extinctions << "Per" << T;
}