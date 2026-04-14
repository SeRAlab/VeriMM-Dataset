module shift_register_8bit(
    input clk,            // Chip clock signal.
    input reset,          // Synchronous reset signal.
    input enable,         // Enable signal for shifting operation.
    input load,           // Signal to load parallel input.
    input [7:0] data_in,  // 8-bit parallel input data.
    output [7:0] q        // 8-bit output of the shift register.
);

reg [7:0] register;       // Shift register.

always @(posedge clk)
    if (reset) register <= 8'b00000000;             // Reset to zero if reset is active.
    else if (load) register <= data_in;             // Load parallel input data if load is active.
    else if (enable) register <= {register[6:0], 1'b0}; // Shift left if enable is active.

assign q = register;                               // Output register value.

endmodule