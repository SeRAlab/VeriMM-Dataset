module top_module(
  input clk,
  input reset_n,
  input enable,
  input d,
  output reg q
);always @(posedge clk or negedge reset_n) begin
  if (!reset_n) begin
    q <= 1'b0;
  end else if (enable) begin
    q <= d;
  end
end

endmodule