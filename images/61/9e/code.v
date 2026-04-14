module dff_sync_reset(
    input clk,     // Chip clock signal.
    input reset,   // Synchronous reset signal. Defined as 1 to reset the output (q) to 0.
    input d,       // Data input signal.

    output reg q   // Data output signal.
);

always @(posedge clk) begin
    if (reset)
        q <= 1'b0; // Reset output to 0
    else
        q <= d;    // Capture data input
end

endmodule