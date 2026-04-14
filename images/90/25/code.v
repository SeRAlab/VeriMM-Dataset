module counter_4bit(
    input clk,          // Chip clock signal.
    input rst,          // Synchronous reset signal.
    output [3:0] count  // Counter output signal with a data width of 4 bits.
);

reg [3:0] count_reg;    // Counter register.

always @(posedge clk)
    if (rst) count_reg <= 4'b0000;               // Reset counter if reset is active.
    else count_reg <= count_reg + 1;             // Increment counter otherwise.

assign count = count_reg;                        // Output counter value.

endmodule