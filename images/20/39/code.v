module memory_allocator(  
    input clk,  
    input reset,  
    input [3:0] block_num,  
    input alloc,  
    input free,  
    output reg [3:0] allocated_blocks,  
    output reg [15:0] memory_status  
);  

    // Initial memory status (16 blocks)  
    initial begin  
        memory_status = 16'b0000000000000000; // All blocks free  
        allocated_blocks = 4'b0000; // Initially no blocks allocated  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            memory_status <= 16'b0000000000000000;  
            allocated_blocks <= 4'b0000;  
        end else begin  
            if (alloc && (memory_status[block_num] == 1'b0)) begin  
                memory_status[block_num] <= 1'b1; // Mark block as allocated  
                allocated_blocks <= allocated_blocks + 1;  
            end  
            if (free && (memory_status[block_num] == 1'b1)) begin  
                memory_status[block_num] <= 1'b0; // Mark block as free  
                allocated_blocks <= allocated_blocks - 1;  
            end  
        end  
    end  
endmodule