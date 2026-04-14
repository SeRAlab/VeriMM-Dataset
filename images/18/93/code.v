module lfsr_32bit (
    input clk,
    input reset,
    input enable,
    output reg [31:0] lfsr_out
);
    // LFSR feedback taps
    wire feedback = lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[9] ^ lfsr_out[8] ^ lfsr_out[7] ^ lfsr_out[5];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 32'hFFFFFFFF; // Reset the LFSR to a non-zero value
        end else if (enable) begin
            lfsr_out <= {lfsr_out[30:0], feedback}; // Shift and insert feedback
        end
    end
endmodule