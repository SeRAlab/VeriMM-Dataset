module memory_allocator #(parameter BLOCK_SIZE = 4, parameter NUM_BLOCKS = 8) (  
    input wire clk,  
    input wire rst,  
    input wire alloc_req,  
    input wire free_req,  
    input wire [2:0] block_index,  
    output reg alloc_success,  
    output reg free_success  
);  
    reg [NUM_BLOCKS-1:0] memory;  
    integer i;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            memory <= {NUM_BLOCKS{1'b0}};  
            alloc_success <= 0;  
            free_success <= 0;  
        end else begin  
            if (alloc_req) begin  
                if (memory[block_index] == 1'b0) begin  
                    memory[block_index] <= 1'b1;  
                    alloc_success <= 1;  
                end else begin  
                    alloc_success <= 0;  
                end  
            end else begin  
                alloc_success <= 0;  
            end  
          
            if (free_req) begin  
                if (memory[block_index] == 1'b1) begin  
                    memory[block_index] <= 1'b0;  
                    free_success <= 1;  
                end else begin  
                    free_success <= 0;  
                end  
            end else begin  
                free_success <= 0;  
            end  
        end  
    end  
endmodule