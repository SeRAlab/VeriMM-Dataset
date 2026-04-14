module linear_feedback_shift_register
(
    input clk,
    input reset,
    output reg [7:0] lfsr
);

    always @(posedge clk) begin
        if (reset) begin
            lfsr <= 8'b00000001; // Set LFSR to initial value
        end else begin
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5]}; // Shift and XOR taps
        end
    end

endmodule