#include <cstdio>
#include <cstring>
#include <cstdlib>

FILE* infile = 0;  
FILE* outfile = 0;  
FILE* ansfile = 0; 

void init(int argc, char* argv[]) { 
	infile = fopen("input", "r");
	outfile = fopen("output", "r");
	ansfile = fopen(argv[1], "r");
}

int main(int argc, char* argv[]) 
{
	init(argc, argv);
	int t;
	fscanf(infile, "%d", &t);
	bool failed = false;
	while (t--) {
		int n;
		fscanf(infile, "%d", &n);
		char nouse[128];
		for (int i = 0; i < n; ++i) {
			fscanf(infile, "%s", nouse);
		}
		char buff[2][128];
		fgets(buff[0], 128, outfile);
		fgets(buff[1], 128, ansfile);
		if (strcmp(buff[0], buff[1]) != 0) {
			failed = true;
			break;
		}
		int ct[3] = {0}, samect = 0;
		for (int i = 0; i < n; ++i) {
			fgets(buff[0], 128, outfile);
			fgets(buff[1], 128, ansfile);
			if (strcmp(buff[0], buff[1]) == 0) ++samect;
			int nowans = -1;
			if (sscanf(buff[1], "%d", &nowans) != 1) {
				failed = true;
				break;
			}
			if (nowans < 0 || nowans > 2) {
				failed = true;
				break;
			}
			++ct[nowans];
		}
		if (failed) break;
		if (samect + samect < n) {
			failed = true;
			break;
		}
		int minn = 0x7FFFFFFF, maxx = -1;
		for (int i = 0; i < 3; ++i) {
			if (ct[i] != 0) {
				if (ct[i] < minn) minn = ct[i];
				if (ct[i] > maxx) maxx = ct[i];
			}
		}
		if (maxx - minn > 1) {
			failed = true;
			break;
		}
	}
	if (failed) {
		puts("Wrong");
		exit(-1);
	}
	else {
		puts("Accepted");
		exit(0);
	}
}
