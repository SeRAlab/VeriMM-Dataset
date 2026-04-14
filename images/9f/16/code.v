module counter_16bit(
    input clk,          // Chip clock signal.
    input en,           // Enable signal.
    output [15:0] count // Counter output signal with a data width of 16 bits.
);

reg [15:0] count_reg;   // Counter register.

always @(posedge clk)
    if (en) count_reg <= count_reg + 1;             // Increment counter if enable is active.

assign count = count_reg;                           // Output counter value.

endmodule