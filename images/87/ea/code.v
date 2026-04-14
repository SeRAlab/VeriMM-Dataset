module shift_reg_64bit(
    input clk,            // Chip clock signal.
    input rst,            // Reset signal.
    input load,           // Load enable signal.
    input shift_left,     // Shift left enable signal.
    input shift_right,    // Shift right enable signal.
    input [63:0] load_data, // 64-bit data to load.
    output reg [63:0] q   // 64-bit output of the shift register.
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 64'b0;           // Reset shift register to zero.
    else if (load)
        q <= load_data;       // Load data into shift register.
    else if (shift_left)
        q <= q << 1;          // Shift left by 1 bit.
    else if (shift_right)
        q <= q >> 1;          // Shift right by 1 bit.
end

endmodule