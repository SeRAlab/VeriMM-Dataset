module adder(
  input [3:0] A,
  input [3:0] B,
  output reg [3:0] Sum
);

  always @(*) begin
    Sum = A + B;
  end
  
endmodule
