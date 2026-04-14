module MemoryAllocator (  
    input clk,  
    input reset,  
    input allocate,  
    input [3:0] alloc_index,  
    input free,  
    input [3:0] free_index,  
    output reg success,  
    output reg [7:0] memory_status  
);  
    reg [1:0] memory [0:15]; // 16 blocks of memory (0: free, 1: allocated)  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 16; i = i + 1) begin  
                memory[i] <= 2'b00; // all blocks are free  
            end  
            memory_status <= 8'b00000000;  
            success <= 0;  
        end else begin  
            if (allocate) begin  
                if (memory[alloc_index] == 2'b00) begin  
                    memory[alloc_index] <= 2'b01; // allocated  
                    success <= 1;  
                end else begin  
                    success <= 0; // allocation failed  
                end  
            end  
            if (free) begin  
                if (memory[free_index] == 2'b01) begin  
                    memory[free_index] <= 2'b00; // freed  
                    success <= 1;  
                end else begin  
                    success <= 0; // free failed  
                end  
            end  
            memory_status <= {memory[15], memory[14], memory[13], memory[12],  
                              memory[11], memory[10], memory[9], memory[8],  
                              memory[7], memory[6], memory[5], memory[4],  
                              memory[3], memory[2], memory[1], memory[0]};  
        end  
    end  
endmodule