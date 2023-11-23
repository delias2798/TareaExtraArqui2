#include <cuda_runtime.h>
#include <iostream>

int main() {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);  // Assuming you are querying device 0
    std::cout << "Compute capability: " << prop.major << "." << prop.minor << std::endl;
    return 0;
}

