module d_flipflop(
  input clk,
  input rst,
  input en,
  input d,
  output reg q
);

  always @(posedge clk) begin
    if (rst)
      q <= 1'b0;
    else if (en)
      q <= d;
  end

endmodule