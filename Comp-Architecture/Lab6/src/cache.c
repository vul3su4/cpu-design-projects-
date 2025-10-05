#include <stdio.h>
#include <math.h>
#include <stdlib.h>

typedef struct {
    int v;
    unsigned int reference;
    unsigned int tag;
} Block;

void stimulate(int cache_size, int block_size, int associativity) {
    int block_num = (cache_size / block_size);
    int index_num = (block_num / associativity);
    
    Block *cache = (Block*)malloc(block_num * sizeof(Block));
    
    for(int i = 0; i < block_num; i++) {
        cache[i].v = 0;
        cache[i].reference = 0;
    }
    
    int offset_bit = (int) log2(block_size);
    int index_bit = (int) log2(index_num);
    
    int *hits = (int*)malloc(10000 * sizeof(int));
    int *misses = (int*)malloc(10000 * sizeof(int));
    int hit_count = 0;
    int miss_count = 0;
    
    FILE *f = fopen("Trace.txt", "r");
    if (f == NULL) {
        printf("Error: Cannot open Trace.txt file\n");
        free(cache);
        free(hits);
        free(misses);
        return;
    }
    
    int instr = 0;
    unsigned int address, index, tag;
    
    while(fscanf(f, "%x", &address) != EOF) {
        instr++;
        index = (address >> offset_bit) & (index_num - 1);
        tag = address >> (offset_bit + index_bit);
        
        int hit = 0;
        int lru_index = 0;
        int lru_ref = cache[index * associativity].reference;
        
        for(int i = 0; i < associativity; i++) {
            if(lru_ref > cache[index * associativity + i].reference) {
                lru_index = i;
                lru_ref = cache[index * associativity + i].reference;
            }
            if(cache[index * associativity + i].v && cache[index * associativity + i].tag == tag) {
                cache[index * associativity + i].reference++;
                hit = 1;
                hits[hit_count++] = instr;
                break;
            }
        }
        
        if(!hit) {
            cache[index * associativity + lru_index].v = 1;
            cache[index * associativity + lru_index].tag = tag;
            cache[index * associativity + lru_index].reference = 1;
            misses[miss_count++] = instr;
        }
    }
    
    printf("Hit instructions: ");
    for(int i = 0; i < hit_count; i++) {
        printf("%d", hits[i]);
        if(i != hit_count - 1) {
            printf(", ");
        }
    }
    printf("\n");
    
    printf("Miss instructions: ");
    for(int i = 0; i < miss_count; i++) {
        printf("%d", misses[i]);
        if(i != miss_count - 1) {
            printf(", ");
        }
    }
    printf("\n");
    
    float missRate = (miss_count / (float)instr) * 100;
    printf("Miss Rate: %.2f%%\n", missRate);
    
    free(cache);
    free(hits);
    free(misses);
    fclose(f);
}

int main() {
    printf("Please input cache_size(byte), block_size(byte), and associativity separated by space.\n");
    int cache_size, block_size, associativity;
    while(scanf("%d %d %d", &cache_size, &block_size, &associativity) == 3) {
        stimulate(cache_size, block_size, associativity);
    }
    
    return 0;
}
