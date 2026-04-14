module vec_multiplier (
  input clk, rst,
  input signed [7:0] vector1,
  input signed [7:0] vector2,
  output reg signed [15:0] product
);

  always @(posedge clk) begin
    if (rst) begin
      product <= 0;
    end
    else begin
      product <= vector1 * vector2;
    end
  end

endmodule