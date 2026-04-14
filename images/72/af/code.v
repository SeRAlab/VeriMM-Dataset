module johnson_counter_10bit(
    input clk,            // Chip clock signal.
    input reset,          // Synchronous reset signal.
    output [9:0] count    // Counter output signal with a data width of 10 bits.
);

reg [9:0] counter;        // Counter register.

always @(posedge clk)
    if (reset) counter <= 10'b0000000000;           // Reset to zero if reset is active.
    else counter <= {~counter[0], counter[9:1]};    // Johnson counter operation.

assign count = counter;                            // Output counter value.

endmodule