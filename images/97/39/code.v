module counter_4bit(
    input clk,          // Chip clock signal.
    input rst,          // Synchronous reset signal.
    input up,           // Up/Down control signal.
    output [3:0] count  // Counter output signal with a data width of 4 bits.
);

reg [3:0] count_reg;    // Counter register.

always @(posedge clk)
    if (rst) count_reg <= 4'b0000;               // Reset counter to 0.
    else if (up) count_reg <= count_reg + 1;     // Increment counter.
    else count_reg <= count_reg - 1;             // Decrement counter.

assign count = count_reg;                        // Output counter value.

endmodule