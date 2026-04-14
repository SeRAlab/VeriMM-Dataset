module top_module(
  input signed [7:0] input_a,
  input signed [7:0] input_b,
  input reset,
  output signed [8:0] sum
);reg signed [8:0] sum_reg;

  always @(*) begin
    if (reset) begin
      sum_reg <= 0;
    end else begin
      sum_reg <= input_a + input_b;
    end
  end

  assign sum = sum_reg;

endmodule