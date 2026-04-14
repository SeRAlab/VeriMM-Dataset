module reg_8bit(
    input clk,          // Chip clock signal.
    input clr,          // Synchronous clear signal.
    input load,         // Load signal for the register.
    input [7:0] d,      // Data input signal with a data width of 8 bits.
    output [7:0] q      // Register output signal with a data width of 8 bits.
);

reg [7:0] q_reg;    // Register.

always @(posedge clk)
    if (clr) q_reg <= 8'b00000000;               // Clear register to 0.
    else if (load) q_reg <= d;                   // Load new value.

assign q = q_reg;                                // Output register value.

endmodule