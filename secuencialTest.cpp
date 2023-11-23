#include <iostream>
#include <chrono>

float dot_product(const float* a, const float* b, size_t size) {
    float sum = 0.0f;
    for (size_t i = 0; i < size; ++i) {
        sum += a[i] * b[i];
    }
    return sum;
}

int main() {
    const size_t N = 40000000;  // Asegúrese de que N sea un múltiplo de 4 por simplicidad
    float* array1 = new float[N];
    float* array2 = new float[N];

    // Inicializar arrays
    for (size_t i = 0; i < N; ++i) {
        array1[i] = static_cast<float>(i);
        array2[i] = static_cast<float>(i * 2);
    }

    // Medir el tiempo de ejecución del producto punto
    auto start = std::chrono::high_resolution_clock::now();
    float result = dot_product(array1, array2, N);
    auto end = std::chrono::high_resolution_clock::now();

    // Calcular y mostrar la duración
    std::chrono::duration<double, std::milli> elapsed = end - start;
    std::cout << "Resultado del producto punto: " << result << std::endl;
    std::cout << "Tiempo de ejecución: " << elapsed.count() << " ms" << std::endl;

    delete[] array1;
    delete[] array2;
    return 0;
}

