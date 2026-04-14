module lfsr_5bit (  
    input clk,  
    input reset,  
    input [4:0] seed,  
    output reg [4:0] lfsr_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr_out <= seed;  
        end else begin  
            // Feedback calculation based on x^5 + x^3 + 1  
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]};  
        end  
    end  
endmodule