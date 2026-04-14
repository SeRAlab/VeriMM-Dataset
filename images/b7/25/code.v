module top_module(
  input a,
  input b,
  input [1:0] c,
  input [1:0] d,
  output reg [2:0] out
);always @(*) begin
  if (a == 1) begin
    out = {c, b};
  end
  else if (b == 1) begin
    out = {2'b1, d[1:0]};
  end
  else begin
    out = {d[0], 2'b0};
  end
end

endmodule