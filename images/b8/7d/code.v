module counter_12bit(
    input clk,          // Chip clock signal.
    input rst,          // Synchronous reset signal.
    input en,           // Enable signal.
    output [11:0] count // Counter output signal with a data width of 12 bits.
);

reg [11:0] count_reg;   // Counter register.

always @(posedge clk)
    if (rst) count_reg <= 12'b000000000000;         // Reset counter if reset is active.
    else if (en) count_reg <= count_reg + 1;        // Increment counter if enable is active.

assign count = count_reg;                           // Output counter value.

endmodule