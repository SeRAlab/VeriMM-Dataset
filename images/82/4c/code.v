module piso_shift_reg_8bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input load,         // Load signal to capture parallel data.
    input [7:0] pdata,  // 8-bit parallel data input.

    output sdata        // Serial data output.
);

reg [7:0] shift_reg; // Register to hold the shift data.

// Shift register logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_reg <= 8'b00000000; // Reset shift register
    else if (load)
        shift_reg <= pdata; // Load parallel data
    else
        shift_reg <= {shift_reg[6:0], 1'b0}; // Shift data out serially
end

assign sdata = shift_reg[7];

endmodule