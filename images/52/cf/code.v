module d_flip_flop(
    input clk,          // Chip clock signal.
    input rst,          // Active-high asynchronous reset signal. Defined as 1 for reset; defined as 0 for normal operation.
    input en,           // Enable signal. Defined as 1 for enable; defined as 0 for disable.
    input d,            // Data input.

    output reg q        // Output data.
);

// Flip-flop logic
always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 1'b0; // Reset output
    else if (en)
        q <= d;    // Follow input
end

endmodule