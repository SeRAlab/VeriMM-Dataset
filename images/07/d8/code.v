module lfsr_16bit (
    input wire clk,
    input wire reset,
    output reg [15:0] lfsr_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 16'h1;  // initialize to non-zero value
        end else begin
            // Feedback taps based on the polynomial x^16 + x^14 + x^13 + x^11 + 1
            lfsr_out <= {lfsr_out[14:0], (lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10])};
        end
    end
endmodule