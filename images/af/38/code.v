module top_module(
  input [3:0] A,
  input [3:0] B,
  input reset,
  output reg match
);always @ (A, B, reset) begin
  if (reset == 1'b1) begin
    match <= 1'b0;
  end else if (A > B) begin
    match <= 1'b1;
  end else begin
    match <= 1'b0;
  end
end

endmodule