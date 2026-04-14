module adder_32bit(
  input [31:0] a,
  input [31:0] b,
  output reg [31:0] sum
);

  always @(*) begin
    sum = a + b;
  end

endmodule