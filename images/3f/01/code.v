module lfsr_5bit (
    input clk,
    input reset,
    output reg [4:0] lfsr_out
);
    initial begin
        lfsr_out = 5'b00001; // Initial state
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 5'b00001; // Reset to initial state
        end else begin
            // Feedback from bit positions 5 and 2
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[1]};
        end
    end
endmodule