module lfsr_16bit (
    input clk,
    input reset,
    input [15:0] seed,
    output reg [15:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= seed; // Load the seed value
        end else begin
            // LFSR feedback using taps at 16, 14, 13, and 11
            out <= {out[14:0], (out[15] ^ out[13] ^ out[12] ^ out[10])}; // taps: 15, 13, 12, 10
        end
    end
endmodule