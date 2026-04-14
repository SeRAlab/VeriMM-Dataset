module top_module(clock_c, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, o1, o2, o3, o4);input  clock_c;
input  i1;
input  i2;
input  [15:0] i3;
input  [15:0] i4;
input  [15:0] i5;
input  [15:0] i6;
input  [15:0] i7;
input  [15:0] i8;
input  [15:0] i9;
input  [15:0] i10;
output [31:0] o1;
output [31:0] o2;
output [31:0] o3;
output [31:0] o4;
wire   [31:0] n1;
reg    [31:0] n2;
wire   [31:0] n3;
reg    [31:0] n4;
wire   [31:0] n5;
reg    [31:0] n6;
wire   [31:0] n7;
reg    [31:0] n8;
assign n1 = {16'b0000000000000000, i3} * {16'b0000000000000000, i7};
always @ (posedge clock_c)
begin
  if (i2 == 1'b1)
    n2 <= 32'b00000000000000000000000000000000;
  else if (i1 == 1'b1)
    n2 <= n1;
  if (i2 == 1'b1)
    n4 <= 32'b00000000000000000000000000000000;
  else if (i1 == 1'b1)
    n4 <= n3;
  if (i2 == 1'b1)
    n6 <= 32'b00000000000000000000000000000000;
  else if (i1 == 1'b1)
    n6 <= n5;
  if (i2 == 1'b1)
    n8 <= 32'b00000000000000000000000000000000;
  else if (i1 == 1'b1)
    n8 <= n7;
end
assign n3 = {16'b0000000000000000, i4} * {16'b0000000000000000, i8};
assign n5 = {16'b0000000000000000, i5} * {16'b0000000000000000, i9};
assign n7 = {16'b0000000000000000, i6} * {16'b0000000000000000, i10};
assign o4 = n8;
assign o3 = n6;
assign o2 = n4;
assign o1 = n2;
endmodule