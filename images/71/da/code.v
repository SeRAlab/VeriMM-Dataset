module top_module(in1, in2, clk, out1, out2);input in1;
  input in2;
  input clk;
  output out1;
  output out2;

  reg in1_reg;
  reg in2_reg;
  reg out1_reg;
  reg out2_reg;

  always @(posedge clk) begin
    in1_reg <= in1;
    in2_reg <= in2;
    out1_reg <= in2_reg;
    out2_reg <= in1_reg;
  end

  assign out1 = out1_reg;
  assign out2 = out2_reg;

endmodule