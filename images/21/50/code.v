module lfsr_5bit (  
    input clk,  
    input rst,  
    input in_bit,  
    output reg [4:0] out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out <= 5'b00001;  // Initial state  
        end else begin  
            out <= {out[3:0], in_bit ^ out[4] ^ out[2]}; // Shift and feedback  
        end  
    end  
endmodule