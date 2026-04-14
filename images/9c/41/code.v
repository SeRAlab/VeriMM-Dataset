module top_module(i1, o1);input  [17:0] i1;
output o1;
wire   n1;
wire   n2;
wire   [16:0] n3;
wire   [17:0] n4;
wire   n5;
wire   [18:0] n6;
wire   [18:0] n7;
wire   n8;
wire   [18:0] n9;
assign n1 = i1[17];
assign n2 = ~n1;
assign n3 = {i1[16],
  i1[15],
  i1[14],
  i1[13],
  i1[12],
  i1[11],
  i1[10],
  i1[9],
  i1[8],
  i1[7],
  i1[6],
  i1[5],
  i1[4],
  i1[3],
  i1[2],
  i1[1],
  i1[0]};
assign n4 = {n2, n3};
assign n5 = 1'b0;
assign n6 = {n5, n4};
assign n7 = n6 - n9;
assign n8 = n7[18];
assign n9 = 19'b0100000000000000000;
assign o1 = n8;endmodule