/*
-----------------
	CHEATSHEET 
-----------------
*/

#include <iostream> //Allows use of cout etc.
#include <vector>
#include <string>
#include <fstream>

using namespace std; //This means we can write 'cout' instead of 'std::cout'

//-----------------FUNCTIONS--------------------
int addNumbers(int a, int b){
//int tells us that an integar will be returned
	int c = a + b;

	return c;
}
//RECURSIVE FUNCTIONS
int Factorial(int number){
	int sum 
	if(number == 1) sum ==1;
	else sum = Factorial(number-1)* number;

	return sum;
}
//-----------------CLASSES----------------------
class Animal{
private:				//These attributes can only be changed by functions in the class
	int height;
	int weight;
	string name;

	static int numOfAnimals; //Attribute which is the same for all objects in class

public:						//Methods that access the values inside
	int getHeight(){ return height;}
	int getWeight(){ return weight;}
	string getName(){return name;}


	
}
//-----------------THE BASICS-------------------
//Create main
int main(){
// cout- what to output
// endl- ends line in terminal
	cout << "Hello World" << endl ; 
 
/*    CHARATER TYPES
double- floating points accurate to 15 dp
char- a single character
string- a string of chars
bool- true(1), false(0)
int- 
float- like double accurate to 6 dp

	Converting TYPES
stoi(string)- converts string to int
stod(string)- converts string to double
*/
const double PI = 3.1415 ; //const makes read only
	char myGrade= 'A';
	double x=4;

	cout << "My Grade: " << myGrade << endl;

//		SIZES- sizeof() function, give size of data in bytes
	cout << "Size of Pi: " << sizeof(PI) << endl;

//		ARITHMETIC- +,-,*,/,%, ++, --, +=
	cout << " 10 * 20 = " << 10*20<< endl;

	cout << " ++x = " << ++x << endl;
	
	cout << "4/5 integar= " << 4/5 << endl;

	cout << "4/5 float= " << (float)4/5 << endl;
	
//		IF STATEMENTS

	int age = 70;
	int ageAtLastExam = 16;
	bool isNotIntoxicated = true;
 
	if((age >= 1) && (age < 16)){
		//If underage
		cout << "You can't drive" << endl;
	
	} else if(! isNotIntoxicated){
		//If drunk
		cout << "You can't drive" << endl;
	
	} else if(age >= 80 && ((age > 100) || ((age - ageAtLastExam) > 5))){
		//If over 80 and (over 100, or  5 years without exam)
		cout << "You can't drive" << endl;
	
	} else {
		cout << "You can drive" << endl;
	}
	
// 			SWITCH - an if statement with limited options
	int y = 2;

	switch(y){
		case 2:
		cout << "y = 2" << endl;
		break; //gets out of case 1
		case 1:
		cout << "y = 1" << endl;
		break;
	
	default: //option if cases are not fulfilled
		cout << "y != 1 or 2" << endl; 
	
	}

//			ARRAYS	
	int Array1[5]; //undefined array with 5 entries
	int Array2[5] = {10,20,30,40,50}; //array with defined entries

	cout << "Array2 value 1 = " << Array2[0] << endl; //calls first entry in array

	char Array3[2][2]={{'A','B'},{'C', 'D'}}; //2D array

	cout <<  "Alphabet " << Array3[0][0] << Array3[1][0] << Array3[0][1] << Array3[1][1] << endl;

//			VECTORS - arrays that can change size
	vector <char> Alph(1); //creates vector of length 1, <'thing a want to store'>

/* 	X.pop_back()					-removes final value
	X.insert(X.begin(), Y, Y+3 )    -inserts 3 numbers from Yinto X at the beginning of X.
	X.push_back(Z)                  -adds Z to the end of X
	
	X.size()						-Number of entries
	X.at(a) 						-Gives ath entry of X
	X.front()						-Give first entry
	X.back()						-Give last entry
	X.empty()						-Give true if empty 
	*/
	Alph.pop_back(); //gets rid of empty entry
	Alph.insert(Alph.begin(), Array3[0], Array3[0]+2); //Adds in A, B
	
	Alph.push_back(Array3[1][0]); //Adds C

	cout << Alph.size() <<endl;
	cout << Alph.at(0) << Alph.at(1) << Alph.at(2) << endl ;


//			FOR LOOP
	for(int i = 2; i <=10; i++){
		//for(start variable; finish; increment)
		cout << i <<endl;
	}

//			WHILE LOOP
	int j = 1 ;
	
	while(j != 10){
		cout << j;
		j = ++j;
	} 
	cout << endl;

//			USER INPUT AND DO
/*getline- Allows user to input line
	getline(cin, a)-user inputs 'a'
  do- while but the other way around */
	string Number;
	int intNumber;

	do {

		cout << "Enter 2" <<endl ;

		getline(cin, Number);

		intNumber = stoi(Number);
	}while(intNumber != 2);


	return 0;

//		CREATING FILES

	string AllStar = "Somebody once told me"; //What you want the file to contain

	ofstream writer("Allstar.txt");

	if
}



/* Run by g++(compiler) -std=c++11(version) Cheatshett.cpp(file)

display output by ./a.out */