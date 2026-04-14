module shift_reg_8bit(
    input clk,        // Chip clock signal.
    input rst_n,      // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input load,       // Load enable signal. 
    input shift_en,   // Shift enable signal.
    input [7:0] din,  // 8-bit parallel input.

    output reg [7:0] dout // 8-bit output of the shift register.
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        dout <= 8'h00; // Reset register to 0
    else if (load) 
        dout <= din; // Load parallel input into register
    else if (shift_en) 
        dout <= {dout[6:0], 1'b0}; // Shift register contents to the left
end

endmodule