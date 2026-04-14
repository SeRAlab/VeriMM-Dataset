module top_module(
  input [1:0] sel,
  input [3:0] a,
  input [3:0] b,
  input [3:0] c,
  input [3:0] d,
  output reg [1:0] out
);always @(*)
begin
  case(sel)
    2'b00: out = a[1:0];
    2'b01: out = b[1:0];
    2'b10: out = c[1:0];
    2'b11: out = d[1:0];
  endcase
end

endmodule