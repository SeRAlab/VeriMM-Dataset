module LFSR_32bit (
    input clk,
    input rst,
    input [31:0] seed,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= seed;
        end else begin
            // Feedback polynomial: x^32 + x^22 + x^21 + x^20 + x^17 + x^16 + x^14 + x^13 + x^11 + x^10 + x^7 + x^5 + x^4 + 1
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[20] ^ lfsr_out[19] ^ lfsr_out[16] ^ lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10] ^ lfsr_out[9] ^ lfsr_out[6] ^ lfsr_out[4] ^ lfsr_out[3] ^ lfsr_out[0]};
        end
    end
endmodule