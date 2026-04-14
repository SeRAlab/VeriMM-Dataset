module lfsr_32bit (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [31:0] seed,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed;
        end else if (enable) begin
            // Tap positions for the polynomial x^32 + x^22 + x^21 + x^20 + 1
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[21] ^ lfsr_out[20]};
        end
    end
endmodule