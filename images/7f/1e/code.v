module counter_4bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input en,           // Enable signal for the counter.
    output [3:0] q      // Counter output signal with a data width of 4 bits.
);

reg [3:0] q_reg;    // Counter register.

always @(posedge clk or negedge rst_n)
    if (!rst_n) q_reg <= 4'b0000;           // Reset counter to 0.
    else if (en) q_reg <= q_reg + 1'b1;     // Increment counter if enable is active.

assign q = q_reg;                           // Output counter value.

endmodule