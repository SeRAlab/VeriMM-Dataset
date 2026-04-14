module fibonacci_lfsr
(
    input clk,
    input reset,
    output reg [5:0] lfsr
);

    always @(posedge clk) begin
        if (reset) begin
            lfsr <= 6'b000001; // Set LFSR to initial value
        end else begin
            lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[4]}; // Shift and XOR taps
        end
    end

endmodule