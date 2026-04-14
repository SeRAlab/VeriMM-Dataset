module gray_counter_6bit(
    input clk,            // Chip clock signal.
    input reset,          // Synchronous reset signal.
    output [5:0] count    // Counter output signal with a data width of 6 bits.
);

reg [5:0] counter;        // Counter register.
reg [5:0] binary_counter; // Binary counter for Gray code conversion.

always @(posedge clk)
    if (reset) binary_counter <= 6'b000000;         // Reset to zero if reset is active.
    else binary_counter <= binary_counter + 6'b000001; // Increment binary counter.

always @(posedge clk)
    counter <= binary_counter ^ (binary_counter >> 1); // Convert binary to Gray code.

assign count = counter;                            // Output Gray code counter value.

endmodule