module top_module(clock_c, i1, i2, i3, i4, i5, o1, o2);input  clock_c;
input  i1;
input  i2;
input  [32:0] i3;
input  [32:0] i4;
input  [32:0] i5;
output [33:0] o1;
output [33:0] o2;
wire   n1;
wire   [33:0] n2;
wire   n3;
wire   [33:0] n4;
wire   [33:0] n5;
reg    [33:0] n6;
wire   n7;
wire   [33:0] n8;
reg    [33:0] n9;
assign n1 = i3[32];
assign n2 = {n1, i3};
assign n3 = i4[32];
assign n4 = {n3, i4};
assign n5 = n2 + n4;
always @ (posedge clock_c)
begin
  if (i2 == 1'b1)
    n6 <= 34'b0000000000000000000000000000000000;
  else if (i1 == 1'b1)
    n6 <= n5;
  if (i2 == 1'b1)
    n9 <= 34'b0000000000000000000000000000000000;
  else if (i1 == 1'b1)
    n9 <= n8;
end
assign n7 = i5[32];
assign n8 = {n7, i5};
assign o2 = n9;
assign o1 = n6;
endmodule