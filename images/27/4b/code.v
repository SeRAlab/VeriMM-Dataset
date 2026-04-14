module lfsr_16bit (
    input clk,
    input reset,
    output reg [15:0] lfsr_out
);
    // Polynomial feedback taps: x^16 + x^14 + x^13 + x^11 + 1
    wire feedback = lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 16'hACE1; // Initial seed value
        end else begin
            lfsr_out <= {lfsr_out[14:0], feedback}; // Shift and feedback
        end
    end
endmodule