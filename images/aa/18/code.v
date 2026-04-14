module top_module(
  input [3:0] a,
  input [3:0] b,
  input [3:0] c,
  output reg [8:0] y
);always @(*)
  begin
    if(a < b)
      y = {a, 5'b0} << c;
    else if(a > b)
      y = {b, 5'b0} << c;
    else
      y = a & b;
  end

endmodule