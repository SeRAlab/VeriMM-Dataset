module lfsr_16bit (
    input clk,
    input rst,
    input [15:0] seed,
    output reg [15:0] lfsr_out
);
    // Taps for the LFSR (for example, taps at 16, 14, 13, and 11)
    wire feedback = lfsr_out[15] ^ lfsr_out[14] ^ lfsr_out[13] ^ lfsr_out[11];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= seed; // Initialize with seed value
        end else begin
            lfsr_out <= {lfsr_out[14:0], feedback}; // Shift and feedback
        end
    end
endmodule