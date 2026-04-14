module up_down_counter_16bit(
    input clk,            // Chip clock signal.
    input reset,          // Synchronous reset signal.
    input up_down,        // Control signal to switch between up and down counting.
    output [15:0] count   // Counter output signal with a data width of 16 bits.
);

reg [15:0] counter;       // Counter register.

always @(posedge clk)
    if (reset) counter <= 16'b0000000000000000;     // Reset to zero if reset is active.
    else if (up_down) counter <= counter + 16'b0000000000000001; // Increment counter if up_down is high.
    else counter <= counter - 16'b0000000000000001; // Decrement counter if up_down is low.

assign count = counter;                            // Output counter value.

endmodule