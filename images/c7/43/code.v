module addition_module (
  input [7:0] A,
  input [7:0] B,
  output reg [8:0] Sum
);

  always @(*) begin
    Sum = A + B;
  end

endmodule
