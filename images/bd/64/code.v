module binary_counter_12bit(
    input clk,              // Chip clock signal.
    input reset,            // Synchronous reset signal.
    input enable,           // Enable signal.
    output [11:0] count     // Counter output signal with a data width of 12 bits.
);

reg [11:0] counter;        // Counter register.

always @(posedge clk)
    if (reset) counter <= 12'b0;                          // Reset to 0 if reset is active.
    else if (enable) counter <= counter + 12'b000000000001; // Increment counter if enable is active.

assign count = counter;                                   // Output counter value.

endmodule