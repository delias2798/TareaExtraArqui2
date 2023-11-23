#include <iostream>
#include <immintrin.h>
#include <chrono>  // Incluir la biblioteca chrono para la medición del tiempo

float dot_product_simd(const float* a, const float* b, size_t size) {
    __m128 sum = _mm_setzero_ps();

    for (size_t i = 0; i < size; i += 4) {
        __m128 va = _mm_loadu_ps(&a[i]);
        __m128 vb = _mm_loadu_ps(&b[i]);
        __m128 dp = _mm_mul_ps(va, vb);
        sum = _mm_add_ps(sum, dp);
    }

    float result[4];
    _mm_storeu_ps(result, sum);
    return result[0] + result[1] + result[2] + result[3];
}

int main() {
    const size_t N = 40000000;
    float* array1 = new float[N];
    float* array2 = new float[N];

    for (size_t i = 0; i < N; ++i) {
        array1[i] = static_cast<float>(i);
        array2[i] = static_cast<float>(i * 2);
    }

    // Iniciar la medición del tiempo
    auto start = std::chrono::high_resolution_clock::now();

    float result = dot_product_simd(array1, array2, N);

    // Detener la medición del tiempo
    auto end = std::chrono::high_resolution_clock::now();

    // Calcular la duración
    std::chrono::duration<double, std::milli> duration = end - start;

    std::cout << "Dot product result: " << result << std::endl;
    std::cout << "Time taken: " << duration.count() << " ms" << std::endl;

    delete[] array1;
    delete[] array2;
    return 0;
}

