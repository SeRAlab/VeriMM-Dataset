module MemoryAllocator #(parameter MEMORY_SIZE = 64, parameter MAX_BLOCKS = 8) (  
    input clk,  
    input rst,  
    input [5:0] request_size,  // size of memory requested  
    input alloc,               // allocation request  
    input free,                // free request  
    input [2:0] block_index,   // index of block to free  
    output reg [5:0] address,   // starting address of allocated block  
    output reg success          // allocation success flag  
);  
    reg [5:0] memory [0:MEMORY_SIZE-1];  
    reg [5:0] block_sizes [0:MAX_BLOCKS-1];  
    reg [2:0] free_list [0:MAX_BLOCKS-1];  
    reg [2:0] free_count;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            success <= 0;  
            free_count <= MAX_BLOCKS;  
            for (i = 0; i < MAX_BLOCKS; i = i + 1) begin  
                free_list[i] <= i;  
                block_sizes[i] <= 0;  
            end  
        end else if (alloc) begin  
            if (request_size > MEMORY_SIZE || free_count == 0) begin  
                address <= 6'b111111; // Indicate failure  
                success <= 0;  
            end else begin  
                address <= free_list[MAX_BLOCKS - free_count];  
                block_sizes[MAX_BLOCKS - free_count] <= request_size;  
                free_count <= free_count - 1;  
                success <= 1;  
            end  
        end else if (free) begin  
            if (block_index < MAX_BLOCKS) begin  
                block_sizes[block_index] <= 0;  
                free_list[MAX_BLOCKS - free_count] <= block_index;  
                free_count <= free_count + 1;  
                success <= 1;  
            end else begin  
                success <= 0;  
            end  
        end  
    end  
endmodule