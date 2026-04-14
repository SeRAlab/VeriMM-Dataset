module memory_manager (  
    input wire clk,  
    input wire rst,  
    input wire request_alloc,  
    input wire request_free,  
    input wire [3:0] alloc_size,  
    output reg [3:0] allocated_size,  
    output reg success  
);  

    parameter TOTAL_MEMORY = 16;  
    reg [3:0] available_memory;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            allocated_size <= 0;  
            available_memory <= TOTAL_MEMORY;  
            success <= 0;  
        end else begin  
            if (request_alloc) begin  
                if (alloc_size <= available_memory) begin  
                    allocated_size <= alloc_size;  
                    available_memory <= available_memory - alloc_size;  
                    success <= 1;  
                end else begin  
                    allocated_size <= 0;  
                    success <= 0;  
                end  
            end else if (request_free) begin  
                available_memory <= available_memory + allocated_size;  
                allocated_size <= 0;  
                success <= 1;  
            end  
        end  
    end  
endmodule