#include <iostream>
#include <vector>
#include <chrono>
#include <fstream>


using namespace std;

// Function to perform serial matrix multiplication
void matrixMultiplicationSerial(const vector<vector<int>>& A, const vector<vector<int>>& B, vector<vector<int>>& C) {
     int rowsA = A.size();
     int colsA = A[0].size();
     int colsB = B[0].size();
    
     // cout<<rowsA<<" "<<colsA<<" "<<colsB<<endl;
    
     for (int i = 0; i < rowsA; ++i) {
          for (int j = 0; j < colsB; ++j) {
            	C[i][j] = 0;
                for (int k = 0; k < colsA; ++k) {
                	C[i][j] += A[i][k] * B[k][j];
                }
          }
     }
}

int main() {
    // Storing data into file so that we can use python to plot the graphs
    string filename = "mat_serial_list_sub_2.out";
    ofstream outFile;
    outFile.open(filename);

    if(outFile.fail()){
	cout<<"Error Opening the file"<<endl;
    }
 
    int elements = 1500;

    vector<double> time;
    vector<int> dimension;
    int rows;
    int cols;    

    for(int i=1;i<elements;i+=5)
	    dimension.push_back(i);

    for(int i=0;i<dimension.size();i++){
        // Matrix dimensions
        int rows = dimension[i];
        int cols = dimension[i];
        
        cout<<rows<<" "<<cols<<endl;
        
        // Used concept of vector of vectors, i.e. row consists of vector.
        // Initialize matrices
        // creates vector A of size = rows * cols with default value = 1
        vector<vector<int>> A(rows, vector<int>(cols, 1));
        // creates vector B of size = cols * rows with default value = 2
        vector<vector<int>> B(cols, vector<int>(rows, 2));
        // created resultant vector of size = rows * rows with default value = 0 
        vector<vector<int>> C(rows, vector<int>(rows, 0));
    
        // Perform serial matrix multiplication
        auto start = chrono::high_resolution_clock::now();
        matrixMultiplicationSerial(A, B, C);
        auto end = chrono::high_resolution_clock::now();
        chrono::duration<double> duration = end - start;

        // Output execution time
        cout << "Serial Execution Time: " << duration.count() << " seconds\n";
        time.push_back(duration.count());
    }
	
    for(auto element : time)
	outFile<<element*1000<<endl;

    return 0;
}                        
