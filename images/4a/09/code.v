module top_module(
  OS1,
  OS2,
  OS3,
  OS4,
  OS5,
  op1,
  op2,
  op3,
  op4,
  op5,
  aSel2,
  aSel3,
  aSel4,
  bSel2,
  bSel3,
  bSel4,
  cSel2,
  cSel3,
  cSel4,
  literalV
  );input [15:0] OS1;
input [15:0] OS2;
input [15:0] OS3;
input [15:0] OS4;
input [15:0] OS5;
output [6:0] op1;
output [6:0] op2;
output [6:0] op3;
output [6:0] op4;
output [6:0] op5;
output [2:0] aSel2;
output [2:0] aSel3;
output [2:0] aSel4;
output [2:0] bSel2;
output [2:0] bSel3;
output [2:0] bSel4;
output [2:0] cSel2;
output [2:0] cSel3;
output [2:0] cSel4;
output [14:0] literalV;

assign literalV=OS2[14:0];

assign op1=OS1[15:9];
assign op2=OS2[15:9];
assign op3=OS3[15:9];
assign op4=OS4[15:9];
assign op5=OS5[15:9];

assign aSel2=OS2[8:6];
assign aSel3=OS3[8:6];
assign aSel4=OS4[8:6];
assign bSel2=OS2[5:3];
assign bSel3=OS3[5:3];
assign bSel4=OS4[5:3];
assign cSel2=OS2[2:0];
assign cSel3=OS3[2:0];
assign cSel4=OS4[2:0];
  
endmodule