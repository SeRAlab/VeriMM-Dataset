module lfsr_8bit(  
    input clk,  
    input reset,  
    output reg [7:0] out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            out <= 8'b1; // Initialize with a non-zero value  
        else begin  
            out <= {out[6:0], out[7] ^ out[5] ^ out[4] ^ out[0]}; // LFSR feedback  
        end  
    end  
endmodule