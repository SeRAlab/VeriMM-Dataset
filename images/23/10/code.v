module MemoryAllocator #(parameter BLOCK_SIZE = 32, parameter NUM_BLOCKS = 4) (  
    input clk,  
    input reset,  
    input [2:0] req_size,  // Request size in number of blocks (1 to NUM_BLOCKS)  
    input allocate,  
    input free,  
    input [1:0] block_id,  // Block ID to free or check status  
    output reg success,  
    output reg [NUM_BLOCKS-1:0] status // Status of each block (1: allocated, 0: free)  
);  
    reg [NUM_BLOCKS-1:0] memory; // 1 means allocated, 0 means free  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            memory <= {NUM_BLOCKS{1'b0}}; // Initialize all blocks as free  
            success <= 0;  
        end  
        else begin  
            if (allocate && (req_size + block_id < NUM_BLOCKS)) begin  
                if (memory[block_id] == 1'b0) begin // Check if that block is free  
                    memory[block_id] <= 1'b1; // Allocate block  
                    success <= 1;  
                end  
                else begin  
                    success <= 0; // Block already allocated  
                end  
            end  
            else if (free) begin  
                if (memory[block_id] == 1'b1) begin // Check if that block is allocated  
                    memory[block_id] <= 1'b0; // Free block  
                    success <= 1;  
                end  
                else begin  
                    success <= 0; // Block already free  
                end  
            end  
            status <= memory; // Update status output  
        end  
    end  
endmodule