module shift_register_8bit(
    input clk,           // Chip clock signal.
    input rst_n,         // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input ld,            // Load signal for parallel data load.
    input [7:0] data_in, // 8-bit parallel data input.

    output [7:0] data_out // 8-bit data output.
);

reg [7:0] shift_reg; // Register to hold the shift register value.

// Shift register logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_reg <= 8'b00000000; // Reset shift register
    else if (ld)
        shift_reg <= data_in;     // Load parallel data
    else
        shift_reg <= {1'b0, shift_reg[7:1]}; // Shift right
end

assign data_out = shift_reg;

endmodule