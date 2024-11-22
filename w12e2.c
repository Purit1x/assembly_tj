#include <windows.h>
#include <stdio.h>

int global_var = 42; // 全局变量

void print_memory_layout() {
    // 获取模块基地址（代码部分的起始地址）
    HMODULE hModule = GetModuleHandle(NULL);
    if (hModule == NULL) {
        printf("Failed to get module handle.\n");
        return;
    }
    printf("Code section start address: %p\n", hModule);

    // 获取全局变量的地址
    printf("Global variable address: %p\n", &global_var);

    // 获取堆区的起始地址
    void* heap_start = HeapAlloc(GetProcessHeap(), 0, 1);
    if (heap_start == NULL) {
        printf("Failed to allocate memory on heap.\n");
        return;
    }
    printf("Heap start address: %p\n", heap_start);
    HeapFree(GetProcessHeap(), 0, heap_start);

    // 获取栈区的起始地址（栈底）
    ULONG_PTR lowAddr, highAddr;
    GetCurrentThreadStackLimits(&lowAddr, &highAddr);
    int stack_var;
    printf("Stack start address (stack bottom): %p\n", (void*)&highAddr);
}

int main() {
    print_memory_layout();
    return 0;
}