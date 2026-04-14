module register_16bit(
    input clk,              // Chip clock signal.
    input enable,           // Enable signal for loading new data.
    input [15:0] data_in,   // Input data with a data width of 16 bits.
    output [15:0] data_out  // Register output signal with a data width of 16 bits.
);

reg [15:0] reg_val;        // Register value.

always @(posedge clk)
    if (enable) reg_val <= data_in;                // Load input value if enable is active.

assign data_out = reg_val;                         // Output register value.

endmodule