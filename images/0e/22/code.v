module lfsr_16bit (  
    input clk,  
    input reset,  
    output reg [15:0] out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 16'b1; // Initial value  
        end else begin  
            out <= {out[14:0], out[15] ^ out[13] ^ out[11] ^ out[0]};  
        end  
    end  
endmodule