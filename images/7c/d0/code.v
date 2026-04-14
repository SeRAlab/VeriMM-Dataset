module register_8bit(
    input clk,             // Chip clock signal.
    input set,             // Synchronous set signal.
    input clr,             // Synchronous clear signal.
    input [7:0] data_in,   // Input data with a data width of 8 bits.
    output [7:0] data_out  // Register output signal with a data width of 8 bits.
);

reg [7:0] reg_data;        // Register data.

always @(posedge clk)
    if (set) reg_data <= 8'b11111111;            // Set register to all 1s if set signal is active.
    else if (clr) reg_data <= 8'b00000000;       // Clear register to all 0s if clear signal is active.
    else reg_data <= data_in;                    // Store input data otherwise.

assign data_out = reg_data;                      // Output register value.

endmodule