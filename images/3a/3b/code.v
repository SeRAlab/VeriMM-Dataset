module lfsr_32bit (
    input clk,
    input reset,
    output reg [31:0] lfsr_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 32'h1; // Initialize to non-zero value
        end else begin
            // Feedback polynomial: x^32 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^3 + x^2 + 1
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[16] ^ lfsr_out[12] ^ lfsr_out[11] ^ lfsr_out[10] ^ lfsr_out[8] ^ lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[3] ^ lfsr_out[2]};
        end
    end
endmodule