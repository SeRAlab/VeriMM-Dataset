module bin2bcd(
  input [11:0] binary_in,
  output reg [15:0] bcd_out
);

  integer i;
  reg [27:0] shift_reg; // 12 bits for binary_in + 16 bits for bcd_out

  always @(*) begin
    shift_reg = {16'd0, binary_in}; // Initialize shift register

    for (i = 0; i < 12; i = i + 1) begin
      // If any of the BCD digits is >= 5, add 3
      if (shift_reg[27:24] >= 5)
        shift_reg[27:24] = shift_reg[27:24] + 3;
      if (shift_reg[23:20] >= 5)
        shift_reg[23:20] = shift_reg[23:20] + 3;
      if (shift_reg[19:16] >= 5)
        shift_reg[19:16] = shift_reg[19:16] + 3;
      if (shift_reg[15:12] >= 5)
        shift_reg[15:12] = shift_reg[15:12] + 3;

      // Shift left by 1
      shift_reg = shift_reg << 1;
    end

    bcd_out = shift_reg[27:12]; // Extract the BCD output
  end

endmodule