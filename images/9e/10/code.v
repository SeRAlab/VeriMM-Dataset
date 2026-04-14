module top_module(
  input clk, rst, set, clr, d,
  output reg q
);always @(posedge clk or negedge rst) begin
  if (~rst) begin
    q <= 1'b0;
  end else if (set) begin
    q <= 1'b1;
  end else if (clr) begin
    q <= 1'b0;
  end else begin
    q <= d;
  end
end

endmodule