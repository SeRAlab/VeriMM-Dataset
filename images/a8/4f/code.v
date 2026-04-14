module d_flip_flop(
  input clk,
  input rst,
  input en,
  input d,
  output reg q
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      q <= 1'b0;
    end else if (en) begin
      q <= d;
    end
  end

endmodule