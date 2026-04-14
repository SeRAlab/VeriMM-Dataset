module memory_allocator #(parameter MEM_SIZE = 32, parameter BLOCK_SIZE = 4) (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] req_size,  
    input wire req_alloc,  
    input wire req_free,  
    input wire [3:0] free_index,  
    output reg [MEM_SIZE-1:0] memory,  
    output reg alloc_success,  
    output reg free_success  
);  

    reg [3:0] alloc_pointer; 
    reg [MEM_SIZE-1:0] mem_array [BLOCK_SIZE-1:0];  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            alloc_success <= 0;  
            free_success <= 0;  
            alloc_pointer <= 0;  
            memory <= 0;  
        end else begin  
            if (req_alloc) begin  
                if (alloc_pointer + req_size <= MEM_SIZE) begin  
                    alloc_success <= 1;  
                    alloc_pointer <= alloc_pointer + req_size;  
                end else begin  
                    alloc_success <= 0;  
                end  
            end else begin  
                alloc_success <= 0;  
            end  

            if (req_free) begin  
                if (free_index < alloc_pointer) begin  
                    free_success <= 1;  
                    alloc_pointer <= alloc_pointer - mem_array[free_index];  
                end else begin  
                    free_success <= 0;  
                end  
            end else begin  
                free_success <= 0;  
            end  
        end  
    end  
endmodule