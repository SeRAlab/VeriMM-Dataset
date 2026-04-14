module lfsr_8bit (
    input clk,
    input reset,
    output reg [7:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 8'b00000001; // Non-zero initial value
        end else begin
            // Feedback taps: 1, 3, 4, 8
            lfsr_out <= {lfsr_out[6:0], lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[0]};
        end
    end
endmodule