module counter_10bit_down(
    input clk,          // Chip clock signal.
    input rst,          // Asynchronous reset signal.
    output [9:0] count  // Counter output signal with a data width of 10 bits.
);

reg [9:0] count_reg;    // Counter register.

always @(negedge clk or posedge rst)
    if (rst) count_reg <= 10'b0000000000;           // Reset counter if reset is active.
    else count_reg <= count_reg - 1;                // Decrement counter on falling edge of clk.

assign count = count_reg;                           // Output counter value.

endmodule