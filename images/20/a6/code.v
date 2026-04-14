module lfsr_8bit (
    input clk,
    input reset,
    output reg [7:0] lfsr_out
);
    
    // Initial seed for the LFSR
    initial begin
        lfsr_out = 8'b10101010; // non-zero initialization
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 8'b10101010; // reset to initial seed
        end else begin
            // Feedback polynomial: x^8 + x^6 + x^5 + x^4 + 1
            lfsr_out <= {lfsr_out[6:0], lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[6]};
        end
    end
endmodule