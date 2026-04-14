module reg_16bit_sync_load(
    input clk,              // Chip clock signal.
    input load,             // Synchronous load signal.
    input [15:0] data_in,   // Input data signal with a data width of 16 bits.
    output [15:0] data_out  // Output data signal with a data width of 16 bits.
);

reg [15:0] register;       // Register.

always @(posedge clk)
    if (load) register <= data_in;                   // Load new value if load is active.

assign data_out = register;                          // Output register value.

endmodule