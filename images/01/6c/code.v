module lfsr_32bit (
    input clk,
    input reset,
    input enable,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 32'h1; // Non-zero seed
        end else if (enable) begin
            // Taps at 32, 22, 2, and 1: x^32 + x^22 + x^2 + 1
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[1] ^ lfsr_out[0]};
        end
    end
endmodule