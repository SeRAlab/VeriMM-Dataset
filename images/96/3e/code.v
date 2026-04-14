module down_counter(
    input clk,          // Chip clock signal.
    input rst,          // Active-high synchronous reset signal. Defined as 1 for chip reset; defined as 0 for reset signal inactive.
    input en,           // Enable signal for the counter.
    output [9:0] q      // Counter output signal with a data width of 10 bits.
);

reg [9:0] q_reg;    // Counter register.

always @(posedge clk)
    if (rst) q_reg <= 10'b0000000000;            // Reset counter to 0.
    else if (en) q_reg <= q_reg - 1;             // Decrement counter by 1.

assign q = q_reg;                                // Output counter value.

endmodule