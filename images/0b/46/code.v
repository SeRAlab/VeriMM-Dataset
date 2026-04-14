module lfsr_32bit(
    input clk,
    input reset,
    input [31:0] seed,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed;
        end else begin
            // Polynomial: x^32 + x^22 + x^18 + x^17 + 1
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[17] ^ lfsr_out[16]};
        end
    end
endmodule