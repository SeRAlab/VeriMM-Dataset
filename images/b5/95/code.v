module binary_comparator
(
  input [3:0] a,
  input [3:0] b,
  output reg [2:0] result
);

  always @(*) begin
    if (a > b) result = 3'b100;
    else if (a < b) result = 3'b010;
    else result = 3'b001;
  end

endmodule