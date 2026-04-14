module LFSR_32bit (
    input clk,
    input reset,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 32'hFFFFFFFF; // Initial state (non-zero)
        end else begin
            // Feedback calculation
            lfsr_out[0] <= lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[18] ^ lfsr_out[17];
            lfsr_out[31:1] <= lfsr_out[30:0]; // Shift left
        end
    end
endmodule