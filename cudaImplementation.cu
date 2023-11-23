#include <iostream>
#include <cuda_runtime.h>
#include <chrono>

// Kernel de CUDA para calcular el producto punto
__global__ void dot_product_kernel(const float* a, const float* b, float* c, size_t size) {
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < size) {
        c[index] = a[index] * b[index];
    }
}

// Función para calcular el producto punto en la GPU
float dot_product_cuda(const float* a, const float* b, size_t size) {
    float* dev_a;
    float* dev_b;
    float* dev_c;
    float* c = new float[size];

    cudaMalloc((void**)&dev_a, size * sizeof(float));
    cudaMalloc((void**)&dev_b, size * sizeof(float));
    cudaMalloc((void**)&dev_c, size * sizeof(float));

    cudaMemcpy(dev_a, a, size * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, size * sizeof(float), cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;
    dot_product_kernel<<<blocksPerGrid, threadsPerBlock>>>(dev_a, dev_b, dev_c, size);

    cudaMemcpy(c, dev_c, size * sizeof(float), cudaMemcpyDeviceToHost);

    float sum = 0.0f;
    for (size_t i = 0; i < size; ++i) {
        sum += c[i];
    }

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    delete[] c;

    return sum;
}

int main() {
    const size_t N = 40000000;
    float* array1 = new float[N];
    float* array2 = new float[N];

    for (size_t i = 0; i < N; ++i) {
        array1[i] = static_cast<float>(i);
        array2[i] = static_cast<float>(i * 2);
    }

    auto start = std::chrono::high_resolution_clock::now();

    float result = dot_product_cuda(array1, array2, N);

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration = end - start;

    std::cout << "Dot product result: " << result << std::endl;
    std::cout << "Time taken (CUDA): " << duration.count() << " ms" << std::endl;

    delete[] array1;
    delete[] array2;
    return 0;
}

