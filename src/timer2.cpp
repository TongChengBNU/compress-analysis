/************************************************************************
 > File Name: src/timer2.cpp
 > Author: Tong Cheng
 > Mail: tong.cheng.8819@outlook.com 
 > Created Time: Wed 20 May 2020 07:41:17 PM CST
************************************************************************/

#include <iostream>
#include <iomanip>
#include <ctime>
using namespace std;

int main(int argc, char *argv[]){
	if(argc != 3){
		cerr << "Usage: " << argv[0] << "<cmd> <repeat>" << endl;
		exit(1);
	}
	int count = atoi(argv[2]);
	if(count == -1){
		fprintf(stderr, "<repeat> parse error.\n");
		exit(1);
	}
	cout << "cmd: " << argv[1] << endl;
	cout << "repeat: " << argv[2] << endl;
	clock_t start, end;
	start = clock();
	for(int i=0; i<count; i++){
		system(argv[1]);
	}
	end = clock();
	cout << "Usage time: " << fixed << setprecision(8) << (double)(end-start)/CLOCKS_PER_SEC << "s" << endl;

	return 0;
}
