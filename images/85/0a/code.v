module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output reg [3:0] Sum,
  output reg Cout
);always @(*) begin
  Sum = A + B + Cin;
  if (Sum > 15) begin
    Cout = 1;
  end else begin
    Cout = 0;
  end
end

endmodule