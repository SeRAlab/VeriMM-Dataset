module top_module(
  input[31:0] a,
  input[31:0] b,
  output reg[31:0] c,
  output overflow
);reg carry;
wire carryXorSign;
wire sameSign;

  xnor signTest(sameSign, a[31], b[31]);
  xor adder(carryXorSign, carry, c[31]);
  and ovrflTest(overflow, carryXorSign, sameSign);

always @(a or b) begin
  {carry, c} = a + b;
end
endmodule