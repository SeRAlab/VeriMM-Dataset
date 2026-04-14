module johnson_counter(
    input clk,           // Chip clock signal.
    input rst_n,         // Active-low synchronous reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    output [5:0] q       // Counter output signal with a data width of 6 bits.
);

reg [5:0] q_reg;      // Counter register.

always @(posedge clk or negedge rst_n)
    if (!rst_n) q_reg <= 6'b000000;              // Reset counter to 0.
    else q_reg <= {q_reg[4:0], ~q_reg[5]};       // Johnson counter sequence.

assign q = q_reg;                                // Output counter value.

endmodule