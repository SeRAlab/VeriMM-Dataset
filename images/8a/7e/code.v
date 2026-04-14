module shift_register_32bit(
    input clk,           // Clock signal.
    input rst,           // Synchronous reset signal.
    input sh_en,         // Shift enable signal.
    input ld_en,         // Load enable signal.
    input [31:0] din,    // 32-bit parallel input data.

    output [31:0] dout   // 32-bit shift register output.
);

reg [31:0] shift_reg; // Shift register.

// Data bit control
always @(posedge clk)
    if (rst) shift_reg <= 32'b0; // Reset condition
    else if (ld_en) shift_reg <= din; // Load parallel data
    else if (sh_en) shift_reg <= {shift_reg[30:0], 1'b0}; // Shift operation

assign dout = shift_reg;

endmodule