module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] src_addr,  
    input wire [7:0] dest_addr,  
    input wire [3:0] num_bytes,  
    output reg busy  
);  
    reg [3:0] count;  
    reg [7:0] src_reg, dest_reg;  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            busy <= 0;  
            count <= 0;  
            src_reg <= 0;  
            dest_reg <= 0;  
        end else if (start && !busy) begin  
            busy <= 1;  
            src_reg <= src_addr;  
            dest_reg <= dest_addr;  
            count <= num_bytes;  
        end else if (busy) begin  
            if (count > 0) begin  
                // Simulate data transfer by decrementing count  
                count <= count - 1;  
            end else begin  
                busy <= 0; // Transfer complete  
            end  
        end  
    end  
endmodule