module bitwise_and(
  input [7:0] input_a,
  input [7:0] input_b,
  output reg [7:0] output_result
);

  always @(*) begin
    output_result = input_a & input_b;
  end

endmodule