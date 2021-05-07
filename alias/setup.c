#include <stdio.h>
#include <stdbool.h>

int main(int argc,char* argv[]){
    char args[100] = "@";
    if(argc<2) return 0;
    for(int i=1;i<argc;i++)
        sprintf(args,"%s%s ",args,argv[i]);
    int posA=1, posB=1;
	bool stat = false;
	while(args[posB] != '\0'){
		if(stat){
			args[posA] = args[posB];
			posA++;
			
		}
		if(args[posB] == '=')
		    stat = true;
		posB++;
	}
	args[posA] = '\0';
	
    printf("%s",args);
    return 0;
}