module MemoryManager #(parameter MEMORY_SIZE = 8, BLOCK_SIZE = 2) (  
    input clk,  
    input rst,  
    input [BLOCK_SIZE-1:0] alloc_request,  
    input [BLOCK_SIZE-1:0] free_request,  
    output reg [MEMORY_SIZE-1:0] memory,  
    output reg alloc_success,  
    output reg free_success  
);  

    reg [MEMORY_SIZE-1:0] mem_blocks;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            memory <= 0;  
            alloc_success <= 0;  
            free_success <= 0;  
            mem_blocks <= 0;  
        end else begin  
            // Handle allocation request  
            if (alloc_request != 0 && mem_blocks[alloc_request] == 0) begin  
                mem_blocks[alloc_request] <= 1;  
                memory[alloc_request] <= 1;  
                alloc_success <= 1;  
            end else begin  
                alloc_success <= 0;  
            end  

            // Handle free request  
            if (free_request != 0 && mem_blocks[free_request] == 1) begin  
                mem_blocks[free_request] <= 0;  
                memory[free_request] <= 0;  
                free_success <= 1;  
            end else begin  
                free_success <= 0;  
            end  
        end  
    end  
endmodule