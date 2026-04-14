module sipo_shift_register_8bit(
    input clk,           // Clock signal.
    input rst,           // Synchronous reset signal.
    input din,           // Serial input bit.

    output [7:0] dout    // 8-bit parallel data output.
);

reg [7:0] shift_reg; // Shift register.

// Data bit control
always @(posedge clk)
    if (rst) shift_reg <= 8'b0; // Reset condition
    else shift_reg <= {shift_reg[6:0], din}; // Shift in the serial input bit

assign dout = shift_reg;

endmodule