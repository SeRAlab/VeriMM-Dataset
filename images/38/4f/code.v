module LFSR_4bit (  
    input clk,  
    input reset,  
    output reg [3:0] out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 4'b0001; // Initial state  
        end else begin  
            out <= {out[2:0], out[3] ^ out[2]}; // Shift left and feedback  
        end  
    end  
endmodule