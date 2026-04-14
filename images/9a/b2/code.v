module shift_reg_8bit(
    input clk,          // Chip clock signal.
    input rst,          // Synchronous reset signal.
    input shift_en,     // Shift enable signal.
    input load,         // Parallel load signal.
    input [7:0] data_in, // 8-bit parallel input data.

    output reg [7:0] q // 8-bit output of the shift register.
);

always @(posedge clk) begin
    if (rst)
        q <= 8'b00000000; // Reset shift register to 0
    else if (load)
        q <= data_in; // Load parallel input data
    else if (shift_en)
        q <= q << 1; // Shift left
end

endmodule