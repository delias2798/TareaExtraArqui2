#include <cuda_runtime.h>
#include <iostream>

__global__ void hello_from_gpu() {
    printf("Hello from GPU!\n");
}

int main() {
    std::cout << "Hello from CPU." << std::endl;
    hello_from_gpu<<<1, 10>>>();
    cudaDeviceSynchronize();
    return 0;
}

