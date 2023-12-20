#include <iostream>
#include <cmath>
#include <chrono>
#include <fstream>
#include <vector>

using namespace std;

// Matrix size (assuming square matrices)
int N;

// CUDA kernel for matrix multiplication
__global__ void matrixMultiplication(float* A, float* B, float* C, int n){

	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int col = blockIdx.x * blockDim.x + threadIdx.x;

	if (row < n && col < n) {
		float sum = 0.0f;
		for (int i = 0; i < n; ++i) {
			sum += A[row * n + i] * B[i * n + col];
		}
		C[row * n + col] = sum;
	}
}

int main() {
	// Storing data into file so that we can use python to plot the graphs
    	string filename = "mat_cuda_sub_2.out";
    	ofstream outFile;
    	outFile.open(filename);

    	if(outFile.fail()){
        	cout<<"Error Opening the file"<<endl;
    	}

	
	//Matrix will be checked for sizes 1-4096
        int elements = 1500;

   	vector<double> time;
    	vector<int> dimension;
    	
    	for(int i=1;i<elements;i+=5)
        	dimension.push_back(i);

    	for(int i=0;i<dimension.size();i++){

		// Matrix allocation and initialization
		N=dimension[i];
        	float *h_A, *h_B, *h_C;
		size_t matrix_size = N * N * sizeof(float);

		h_A = new float[N * N];
		h_B = new float[N * N];
		h_C = new float[N * N];

		for (int i = 0; i < N * N; ++i) {
			h_A[i] = 1;
			h_B[i] = 2;
			h_C[i] = 0;
		}
	
		// start the timer for the execution phase
		auto start = chrono::high_resolution_clock::now();

		// CUDA memory allocation
		float *d_A, *d_B, *d_C;
		cudaMalloc(&d_A, matrix_size);
		cudaMalloc(&d_B, matrix_size);
		cudaMalloc(&d_C, matrix_size);

		// Copy matrices from host to device
		cudaMemcpy(d_A, h_A, matrix_size, cudaMemcpyHostToDevice);
		cudaMemcpy(d_B, h_B, matrix_size, cudaMemcpyHostToDevice);

		// Define block and grid dimensions
		dim3 blockSize(16, 16);
		dim3 gridSize((N + blockSize.x - 1) / blockSize.x, (N + blockSize.y - 1) / blockSize.y);

		// Launch kernel
		matrixMultiplication<<<gridSize, blockSize>>>(d_A, d_B, d_C, N);

		// Copy result from device to host
		cudaMemcpy(h_C, d_C, matrix_size, cudaMemcpyDeviceToHost);

		//Free CUDA memory
		cudaFree(d_A);
		cudaFree(d_B);
		cudaFree(d_C);

		// Free host memory
		delete[] h_A;
		delete[] h_B;
		delete[] h_C;
   
		auto end = chrono::high_resolution_clock::now();
	   	chrono::duration<double> duration = end - start;
		
		cout<<N<<" "<<N<<endl;
    		cout<<"Parallel Execution Time :  "<< duration.count() << " seconds\n";
		time.push_back(duration.count());
	}
	for(auto element : time)
	        outFile<<element*1000<<endl;

	return 0;
}
