module top_module(
  input [3:0] a,
  input [3:0] b,
  input ctrl,
  output [3:0] sum
);reg [3:0] sum_reg;

  always @(*) begin
    if (ctrl == 1'b1) begin
      sum_reg = a + b;
    end
  end

  assign sum = sum_reg;

endmodule