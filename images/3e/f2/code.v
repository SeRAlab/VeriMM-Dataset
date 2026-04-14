module lfsr_16bit (
    input wire clk,
    input wire reset,
    output reg [15:0] lfsr_out
);
    // Polynomial feedback taps at positions 16, 14, 13, 11
    wire feedback = lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 16'hA001; // Initial seed value
        end else begin
            lfsr_out <= {lfsr_out[14:0], feedback}; // Shift left and insert feedback
        end
    end
endmodule