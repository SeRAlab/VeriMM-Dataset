module counter_6bit_set(
    input clk,          // Chip clock signal.
    input rst,          // Synchronous reset signal.
    input en,           // Enable signal.
    input set,          // Synchronous set signal.
    input [5:0] set_value, // Value to set the counter.
    output [5:0] count  // Counter output signal with a data width of 6 bits.
);

reg [5:0] count_reg;    // Counter register.

always @(posedge clk)
    if (rst) count_reg <= 6'b000000;                // Reset counter if reset is active.
    else if (set) count_reg <= set_value;           // Set counter to set_value if set is active.
    else if (en) count_reg <= count_reg + 1;        // Increment counter if enable is active.

assign count = count_reg;                           // Output counter value.

endmodule