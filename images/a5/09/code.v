module counter_updown(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input en,           // Enable signal for the counter.
    input dir,          // Direction signal for counting. High for up, low for down.
    output [7:0] q      // Counter output signal with a data width of 8 bits.
);

reg [7:0] q_reg;    // Counter register.

always @(posedge clk or negedge rst_n)
    if (!rst_n) q_reg <= 8'b00000000;            // Reset counter to 0.
    else if (en) q_reg <= dir ? q_reg + 1 : q_reg - 1; // Increment or decrement counter based on direction.

assign q = q_reg;                                // Output counter value.

endmodule