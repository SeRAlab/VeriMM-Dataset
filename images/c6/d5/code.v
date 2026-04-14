module four_bit_adder(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] S,
  output Cout
);

  reg [3:0] S;
  reg Cout;

  always @(*) begin
    {Cout, S} = A + B + Cin;
  end

endmodule