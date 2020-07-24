/************************************************************************
 > File Name: regex.cpp
 > Author: Tong Cheng
 > Mail: tong.cheng.8819@outlook.com 
 > Created Time: Mon 18 May 2020 12:20:21 PM CST
************************************************************************/


#include <iostream>
#include <fstream>
#include <vector>
#include <regex>
#include <string>

using namespace std;

vector<string> parse(string strValue);

int main(int argc, char* argv[]){
	
	if(argc < 2){
		cerr << "Usage: " << argv[0] << " <file>" << endl;
		exit(1);
	}

	ifstream in(argv[1]); // open input file
	if(!in){
		cerr << "Open file " << argv[1] << " error;" << endl;
		exit(1);
	}

	string line;

	while(!in.eof()){
		in >> line;
		//cout << line << endl;
		vector<string> container = parse(line);
		for(auto ele: container){
			if(ele == "unchanged"){
				ele = "0%";
			}
			cout << ele << endl;
		}	
	}

	

	/*
	in.seekg(0, ios::beg);
	while(getline(in, line)){
		cout << "Src: " << line << endl;
		if( regex_match(line, regex("^real")) ){
			cout << line << endl;
		}
	}
	*/
	
	
	in.close();
	return 0;
}


vector<string> parse(string strValue){
	smatch result;
	vector<string> container;
	regex pattern("-*[1-9]*[0-9]*.?[0-9]*%|unchanged");	
	string::const_iterator iterStart = strValue.begin();
	string::const_iterator iterEnd = strValue.end();
	while( regex_search(iterStart, iterEnd, result, pattern)){
		container.push_back(result[0]);
		iterStart = result[0].second;
	}
	return container;
}
