module shift_register_32bit(
    input clk,              // Chip clock signal.
    input reset,            // Synchronous reset signal.
    input shift_left,       // Control signal to shift left.
    input shift_right,      // Control signal to shift right.
    input [31:0] data_in,   // Input data signal with a data width of 32 bits.
    output [31:0] data_out  // Output data signal with a data width of 32 bits.
);

reg [31:0] register;       // Shift register.

always @(posedge clk)
    if (reset) register <= 32'b0;                          // Reset to 0 if reset is active.
    else if (shift_left) register <= {register[30:0], 1'b0}; // Shift left if shift_left is active.
    else if (shift_right) register <= {1'b0, register[31:1]}; // Shift right if shift_right is active.

assign data_out = register;                               // Output register value.

endmodule