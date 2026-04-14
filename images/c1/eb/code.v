module adder_4bit(Cin, A, B, Clk, En, Rst, Sum, Cout);
  input Cin, A, B, Clk, En, Rst;
  output [3:0] Sum;
  output Cout;

  reg [3:0] Sum_reg;
  reg Cout_reg;

  always @(posedge Clk) begin
    if (Rst) begin
      Sum_reg <= 4'b0000;
      Cout_reg <= 1'b0;
    end else if (En) begin
      {Cout_reg, Sum_reg} <= Cin + A + B + Sum_reg;
    end
  end

  assign Sum = Sum_reg;
  assign Cout = Cout_reg;

endmodule