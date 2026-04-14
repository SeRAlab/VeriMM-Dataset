module up_counter_with_load(
    input clk,             // Chip clock signal.
    input rst,             // Active-high synchronous reset signal. Defined as 1 for chip reset; defined as 0 for reset signal inactive.
    input en,              // Enable signal for the counter.
    input load,            // Load signal for the counter.
    input [11:0] load_value, // 12-bit value to be loaded into the counter.
    output [11:0] q        // Counter output signal with a data width of 12 bits.
);

reg [11:0] q_reg;     // Counter register.

always @(posedge clk)
    if (rst) q_reg <= 12'b000000000000;          // Reset counter to 0.
    else if (load) q_reg <= load_value;          // Load value into counter.
    else if (en) q_reg <= q_reg + 1;             // Increment counter by 1.

assign q = q_reg;                                // Output counter value.

endmodule