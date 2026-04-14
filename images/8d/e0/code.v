module top_module(clock_c, i1, i2, i3, o1, o2, o3, o4, o5, o6, o7, o8);input  clock_c;
input  i1;
input  i2;
input  [15:0] i3;
output [15:0] o1;
output [15:0] o2;
output [15:0] o3;
output [15:0] o4;
output [15:0] o5;
output [15:0] o6;
output [15:0] o7;
output [15:0] o8;
reg    [15:0] n1;
reg    [15:0] n2;
reg    [15:0] n3;
reg    [15:0] n4;
reg    [15:0] n5;
reg    [15:0] n6;
reg    [15:0] n7;
reg    [15:0] n8;
always @ (posedge clock_c)
begin
  if (i2 == 1'b1)
    n1 <= 16'b0000000000000000;
  else if (i1 == 1'b1)
    n1 <= i3;
  if (i2 == 1'b1)
    n2 <= 16'b0000000000000000;
  else if (i1 == 1'b1)
    n2 <= n1;
  if (i2 == 1'b1)
    n3 <= 16'b0000000000000000;
  else if (i1 == 1'b1)
    n3 <= n2;
  if (i2 == 1'b1)
    n4 <= 16'b0000000000000000;
  else if (i1 == 1'b1)
    n4 <= n3;
  if (i2 == 1'b1)
    n5 <= 16'b0000000000000000;
  else if (i1 == 1'b1)
    n5 <= n4;
  if (i2 == 1'b1)
    n6 <= 16'b0000000000000000;
  else if (i1 == 1'b1)
    n6 <= n5;
  if (i2 == 1'b1)
    n7 <= 16'b0000000000000000;
  else if (i1 == 1'b1)
    n7 <= n6;
  if (i2 == 1'b1)
    n8 <= 16'b0000000000000000;
  else if (i1 == 1'b1)
    n8 <= n7;
end
assign o8 = n8;
assign o7 = n7;
assign o6 = n6;
assign o5 = n5;
assign o4 = n4;
assign o3 = n3;
assign o2 = n2;
assign o1 = n1;
endmodule