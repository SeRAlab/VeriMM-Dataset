module memory_allocator #(parameter BLOCK_SIZE = 8, parameter NUM_BLOCKS = 16) (  
    input clk,  
    input reset,  
    input [3:0] request_size, // size of the memory block to allocate  
    input allocate,  
    input free,  
    input [3:0] block_index, // index of the block to free  
    output reg [NUM_BLOCKS-1:0] allocated, // bitmap of allocated blocks  
    output reg allocation_success // indicates if allocation was successful  
);  
    reg [NUM_BLOCKS-1:0] memory_blocks; // memory block status  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            allocated <= 0;  
            allocation_success <= 0;  
            memory_blocks <= 0;  
        end else begin  
            if (allocate) begin  
                if (request_size <= BLOCK_SIZE && !memory_blocks[block_index]) begin  
                    memory_blocks[block_index] <= 1;  
                    allocated <= memory_blocks;  
                    allocation_success <= 1;  
                end else begin  
                    allocation_success <= 0;  
                end  
            end  
            if (free) begin  
                memory_blocks[block_index] <= 0;  
                allocated <= memory_blocks;  
            end  
        end  
    end  
endmodule