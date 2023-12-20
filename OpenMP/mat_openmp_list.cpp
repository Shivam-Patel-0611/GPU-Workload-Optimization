#include <omp.h>
#include <iostream>
#include <vector>
#include <fstream>
#include <chrono>

using namespace std;

//Matrix size (assuming square matrices)
int N;

// Function to initialize a matrix with random values
void initializeMatrix(vector<vector<double>>& matrix) {
	for (int i = 0; i < N; ++i) {
		for (int j = 0; j < N; ++j) {
			matrix[i][j] = rand() % 10;  // Assign a random value between 0 and 9
		}
	}	
}

// Function to multiply two matrices (C = A * B)
void matrixMultiply(vector<vector<double>>& A,vector<vector<double>>& B,vector<vector<double>>& C) {
	#pragma omp parallel for
	for (int i = 0; i < N; ++i) {
		for (int j = 0; j < N; ++j) {
			C[i][j] = 0.0;
			for (int k = 0; k < N; ++k) {
				C[i][j] += A[i][k] * B[k][j];
			}
		}
	}
}

int main() {
	
	// Storing data into file so that we can use python to plot the graphs
	string filename = "mat_openmp_list_sub_2.out";
	ofstream outFile;
	outFile.open(filename);
	
	if(outFile.fail()){
	cout<<"Error Opening the file"<<endl;
	}
	
	int elements = 1500;
	vector<double> time;
	vector<int> dimension;
	
	for(int i=1;i<elements;i+=5)
		dimension.push_back(i);
	
	for(int i=0;i<dimension.size();i++){
		// Matrix dimensions
		N = dimension[i];
		cout<<N<<" "<<N<<endl;

		// Matrix allocation and initialization
		vector<vector<double>> A(N, vector<double>(N));
		vector<vector<double>> B(N, vector<double>(N));
		vector<vector<double>> C(N, vector<double>(N));

		// Initialize matrices
		initializeMatrix(A);
		initializeMatrix(B);
		
		// Perform serial matrix multiplication
		auto start = chrono::high_resolution_clock::now();
		matrixMultiply(A, B, C);
		auto end = chrono::high_resolution_clock::now();
		chrono::duration<double> duration = end - start;
		
		//Output execution time
	        cout << "OpenMP Execution Time: " << duration.count() << " seconds\n";
	        time.push_back(duration.count());
	}
		
	for(auto element : time)
		outFile<<element*1000<<endl;
		
	return 0;
}
