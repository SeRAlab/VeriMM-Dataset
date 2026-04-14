module lfsr_32bit(  
    input clk,  
    input reset,  
    input [31:0] seed,  
    output reg [31:0] out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= seed;  
        end else begin  
            out <= {out[30:0], out[31] ^ out[22] ^ out[17] ^ out[13]};  
        end  
    end  
endmodule