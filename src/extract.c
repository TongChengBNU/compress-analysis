#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int sizeMethod(char *path, int size, char *buffer);
int percentageMethod(char *path, double percentage, char *buffer);


int main(int argc, char *argv[]){
	if( argc!=6 || argv == NULL ){
		fprintf(stderr, "Usage: %s <data> [-s <frame-size> |-p <percentage>] -o <output>\n", argv[0]);
		exit(1);
	}
	// parse option
	char option;
	char *buffer=NULL;
	buffer = (char *)malloc(1024);

	int length=-1; // len of buffer
	double percentage;
	for(int i=2; i<argc; i++){
		if( argv[i][0] == '-' ){
			option = *++argv[i];
			switch(option){
				case 's':
					length = sizeMethod(argv[1], atoi(argv[3]), buffer);
					break;	
				case 'p':
					length = percentageMethod(argv[1], atof(argv[3]), buffer);
					break;	
				case 'o':
					// printf("%d\n", length);
					if(length >= 0){
						FILE *wrt;
						wrt = fopen(argv[5], "wb");
						if(wrt == NULL){
							fprintf(stderr, "Write path error;\n");
							return -1;
						}
						fwrite(buffer, sizeof(char), length, wrt);
						fclose(wrt);
						free(buffer);
					}else{
						fprintf(stderr, "Nothing to output;\n");
						return -1;
					}
					break;
				default:
					fprintf(stderr, "Unsupported option;\n");
					break;
			}
		}
	}

	return 0;
}

int sizeMethod(char *path, int size, char *buffer){
	FILE *rd;
	if( (rd = fopen(path, "rb")) == NULL ){
		fprintf(stderr, "Open %s error\n", path);
		exit(1);
	}

	fseek(rd, 0L, 2); // ptr to tail
	long int length = ftell(rd);
	rewind(rd); // back to head

	srand( (unsigned)time(NULL) );
	long begin;
	if( length >= size ){
		begin = rand() % (length - size);
	}else{
		fprintf(stderr, "size bigger than length;\n");
		return -1;		
	}
	fseek(rd, begin, 0); // ptr to head with offset $begin

	/* Debug
	fprintf(stderr, "Path: %s, size: %d\n", path, size);
	fprintf(stderr, "Begin: %ld, length: %ld\n", begin, length);
	*/


	buffer = (char *)malloc(size);
	fread(buffer, sizeof(char), size, rd);
	// don't dump binary into stdout !!!
	//fprintf(stdout, "%s", buffer);
	// sizeof cannot measure dynamic memory

	fclose(rd);
	return size;
}

int percentageMethod(char *path, double percentage, char *buffer){
	FILE *rd;
	if( (rd = fopen(path, "rb")) == NULL ){
		fprintf(stderr, "Open %s error\n", path);
		return -1;
	}

	fseek(rd, 0L, 2); // ptr to tail
	long int length = ftell(rd);
	rewind(rd); // back to head
	fclose(rd);
	
	int size = (int)(length * percentage);
	return sizeMethod(path, size, buffer);
}
