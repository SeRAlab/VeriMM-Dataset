module memory_allocator(  
    input clk,  
    input reset,  
    input [1:0] request_type, // 00: free, 01: allocate  
    input [3:0] block_index,  
    output reg success  
);  
    reg [15:0] memory; // 16 blocks of memory  
    initial begin  
        memory = 16'b0000000000000000; // All blocks are initially free  
        success = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            memory <= 16'b0000000000000000; // Reset memory  
            success <= 0;  
        end else begin  
            case (request_type)  
                2'b01: // Allocate  
                    if (memory[block_index] == 0) begin  
                        memory[block_index] <= 1;  
                        success <= 1;  
                    end else begin  
                        success <= 0;  
                    end  
                2'b00: // Free  
                    if (memory[block_index] == 1) begin  
                        memory[block_index] <= 0;  
                        success <= 1;  
                    end else begin  
                        success <= 0;  
                    end  
                default: success <= 0;  
            endcase  
        end  
    end  
endmodule