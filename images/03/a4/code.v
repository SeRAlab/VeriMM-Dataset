module lfsr_32bit (  
    input clk,  
    input reset,  
    output reg [31:0] out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 32'b1; // Initialize to a non-zero value  
        end else begin  
            out <= {out[30:0], (out[31] ^ out[22] ^ out[13] ^ out[11] ^ out[10] ^ out[5] ^ out[4])};  
        end  
    end  
endmodule