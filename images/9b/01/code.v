module binary_counter(
    input clk,          // Chip clock signal.
    input rst,          // Active-high reset signal. Defined as 1 for chip reset; defined as 0 for reset signal inactive.
    input en,           // Enable signal for the counter.
    output [3:0] q      // Counter output signal with a data width of 4 bits.
);

reg [3:0] q_reg;    // Counter register.

always @(posedge clk)
    if (rst) q_reg <= 4'b0000;                   // Reset counter to 0.
    else if (en) q_reg <= q_reg + 1;             // Increment counter by 1.

assign q = q_reg;                                // Output counter value.

endmodule