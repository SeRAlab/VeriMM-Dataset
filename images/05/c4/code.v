module memory_allocator #(parameter NUM_BLOCKS = 8) (  
    input clk,  
    input rst,  
    input alloc,  // Allocate signal  
    input free,   // Free signal  
    output reg [NUM_BLOCKS-1:0] memory_status // 1 for allocated, 0 for free  
);  

    reg [2:0] next_block; // To track the next block to be allocated  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            memory_status <= 0; // Initialize memory to all free  
            next_block <= 0;  
        end  
        else begin  
            if (alloc && (memory_status != (1 << NUM_BLOCKS) - 1)) begin  
                // Allocate memory block  
                memory_status[next_block] <= 1;  
                next_block <= (next_block + 1) % NUM_BLOCKS;  
            end  
            if (free) begin  
                // Free the last allocated block  
                memory_status[next_block - 1] <= 0;  
            end  
        end  
    end  
endmodule