module shift_reg(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input en,           // Enable signal for the shift register.
    input load,         // Load signal for parallel loading.
    input [3:0] d,      // Parallel data input signal with a data width of 4 bits.
    output [3:0] q      // Shift register output signal with a data width of 4 bits.
);

reg [3:0] q_reg;    // Shift register.

always @(posedge clk or negedge rst_n)
    if (!rst_n) q_reg <= 4'b0000;               // Reset shift register to 0.
    else if (load) q_reg <= d;                  // Load parallel data input.
    else if (en) q_reg <= {q_reg[2:0], 1'b0};   // Shift left by one position.

assign q = q_reg;                               // Output shift register value.

endmodule