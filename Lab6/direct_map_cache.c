#include <stdio.h>
#include <math.h>
#include <stdlib.h>

typedef struct {
    int v;
    unsigned int tag;
} cache_content;

const int K = 1024;

void simulate(int cache_size, int block_size) {
    unsigned int tag, index, x;
    
    int offset_bit = (int) log2(block_size);
    int index_bit = (int) log2(cache_size / block_size);
    int line = cache_size >> offset_bit;
    
    cache_content *cache = (cache_content*)malloc(line * sizeof(cache_content));
    printf("cache line: %d\n", line);
    
    for(int j = 0; j < line; j++) {
        cache[j].v = 0;
    }
    
    FILE *fp = fopen("Trace.txt", "r");
    if (fp == NULL) {
        printf("Error: Cannot open Trace.txt file\n");
        free(cache);
        return;
    }
    
    while(fscanf(fp, "%x", &x) != EOF) {
        printf("%x ", x);
        index = (x >> offset_bit) & (line - 1);
        tag = x >> (index_bit + offset_bit);
        
        if(cache[index].v && cache[index].tag == tag) {
            cache[index].v = 1;  // hit
        } else {
            cache[index].v = 1;  // miss
            cache[index].tag = tag;
        }
    }
    fclose(fp);
    
    free(cache);
}

int main() {
    // Let us simulate 4KB cache with 16B blocks
    simulate(4 * K, 16);
    return 0;
}
