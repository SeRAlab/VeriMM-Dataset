module memory_controller(  
    input clk,  
    input reset,  
    input request,  
    input [3:0] block_size,  
    input allocate,  
    output reg [7:0] allocated_memory,  
    output reg success  
);  
    reg [7:0] total_memory;  
    initial begin  
        total_memory = 8'd128; // 128 bytes of total memory  
        allocated_memory = 8'd0;  
        success = 1'b0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            allocated_memory <= 8'd0;  
            success <= 1'b0;  
        end else if (request) begin  
            if (allocate) begin  
                if (allocated_memory + block_size <= total_memory) begin  
                    allocated_memory <= allocated_memory + block_size;  
                    success <= 1'b1;  
                end else begin  
                    success <= 1'b0; // Not enough memory  
                end  
            end else begin  
                if (allocated_memory >= block_size) begin  
                    allocated_memory <= allocated_memory - block_size;  
                    success <= 1'b1;  
                end else begin  
                    success <= 1'b0; // Not enough allocated memory to free  
                end  
            end  
        end  
    end  
endmodule