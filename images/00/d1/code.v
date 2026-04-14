module lfsr_16bit(  
    input clk,  
    input reset,  
    output reg [15:0] out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            out <= 16'h1; // Initialize to a non-zero state  
        else begin  
            out <= {out[14:0], out[15] ^ out[13] ^ out[11] ^ out[0]}; // Feedback polynomial  
        end  
    end  
endmodule