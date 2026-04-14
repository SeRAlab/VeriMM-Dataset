module top_module(
  input          clock,
  input          reset,
  input   [7:0] a,
  input   [7:0] b,
  output [7:0]  sum
);reg [8:0] sum_reg;

  always @(posedge clock) begin
    if (reset) begin
      sum_reg <= 8'b0;
    end else begin
      sum_reg <= a + b;
    end
  end

  assign sum = sum_reg[7:0];

endmodule