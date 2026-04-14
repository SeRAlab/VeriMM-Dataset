module comparator_3bit (
  input [2:0] A,
  input [2:0] B,
  output reg [1:0] result
);

  always @* begin
    if (A > B)
      result = 2'b01;
    else if (A == B)
      result = 2'b00;
    else
      result = 2'b11;
  end

endmodule
