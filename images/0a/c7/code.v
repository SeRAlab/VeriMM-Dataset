module memory_allocator #(parameter MEMORY_SIZE = 16) (  
    input clk,  
    input reset,  
    input [3:0] req_size,  // Requested size for allocation (1 to 15)  
    input req_alloc,       // Request allocation signal  
    input req_free,        // Request free signal  
    input [3:0] block_id,  // Identifier for the block to free  
    output reg success,     // Success flag  
    output reg [3:0] allocated_block  // ID of allocated block  
);  

    reg [MEMORY_SIZE-1:0] memory;  
    reg [3:0] free_blocks [0:MEMORY_SIZE-1];  
    reg [3:0] block_count;  

    initial begin  
        memory = 0;  
        block_count = 0;  
        success = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            memory = 0;  
            block_count = 0;  
            success = 0;  
        end else begin  
            if (req_alloc && block_count < MEMORY_SIZE) begin  
                if (req_size > 0 && req_size <= MEMORY_SIZE - block_count) begin  
                    success = 1;  
                    allocated_block = block_count;  
                    block_count = block_count + req_size;  
                    memory[allocated_block] = 1; // Mark block as allocated  
                end else begin  
                    success = 0; // Allocation fails  
                end  
            end else if (req_free) begin  
                if (block_id < MEMORY_SIZE && memory[block_id]) begin  
                    success = 1;  
                    memory[block_id] = 0; // Mark block as free  
                    block_count = block_count - 1;  
                end else begin  
                    success = 0; // Free fails  
                end  
            end  
        end  
    end  
endmodule