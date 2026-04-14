module LFSR_32bit (  
    input clk,  
    input reset,  
    input [31:0] seed,  
    output reg [31:0] lfsr_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr_out <= seed;  
        end else begin  
            // LFSR feedback taps (example: taps at 32, 22, 17, 16, 14, 13, 11, 10, 7, 5, 3, 1)  
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[17] ^ lfsr_out[16] ^ lfsr_out[14] ^ lfsr_out[13] ^ lfsr_out[11] ^ lfsr_out[10] ^ lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[3] ^ lfsr_out[1]};  
        end  
    end  
endmodule