module johnson_counter_8bit(
    input clk,             // Chip clock signal.
    input reset,           // Synchronous reset signal.
    output [7:0] count     // Counter output signal with a data width of 8 bits.
);

reg [7:0] counter;        // Johnson counter register.

always @(posedge clk)
    if (reset) counter <= 8'b00000001;                    // Reset to initial state if reset is active.
    else counter <= {counter[6:0], ~counter[7]};          // Shift left and wrap the inverted leftmost bit.

assign count = counter;                                   // Output counter value.

endmodule