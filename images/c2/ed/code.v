module unsigned_multiplier(
  input [7:0] a,
  input [7:0] b,
  output [15:0] p
);

  reg [7:0] a_reg;
  reg [15:0] p_reg;

  integer i, j;

  always @(*) begin
    a_reg = a;
    p_reg = 0;

    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 8; j = j + 1) begin
        if ((i + j) < 16) begin
          p_reg[i + j] = p_reg[i + j] + a_reg[i] * b[j];
        end
      end
    end
  end

  assign p = p_reg;

endmodule