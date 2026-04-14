module counter_5bit(
    input clk,             // Chip clock signal.
    input ctrl,            // Control signal for up/down counting.
    output [4:0] count     // Counter output signal with a data width of 5 bits.
);

reg [4:0] count_reg;       // Counter register.

always @(posedge clk)
    if (ctrl) count_reg <= count_reg + 1;        // Increment counter if control signal is high.
    else count_reg <= count_reg - 1;             // Decrement counter if control signal is low.

assign count = count_reg;                        // Output counter value.

endmodule