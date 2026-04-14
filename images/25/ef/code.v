module lfsr_16bit (  
    input clk,  
    input reset_n,  
    input next,  
    output reg [15:0] lfsr_out  
);  
    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            lfsr_out <= 16'h1; // Initial state  
        end else if (next) begin  
            // LFSR feedback polynomial: x^16 + x^14 + x^13 + x^11 + 1  
            lfsr_out <= {lfsr_out[14:0], lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10]};  
        end  
    end  
endmodule