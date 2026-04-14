module d_ff(
    input clk,     // Chip clock signal.
    input clr_n,   // Active-low asynchronous clear signal.
    input d,       // Input signal.

    output reg q   // Output signal.
);

always @(posedge clk or negedge clr_n) begin
    if (!clr_n)
        q <= 1'b0; // Clear output to 0
    else
        q <= d; // Capture input value
end

endmodule