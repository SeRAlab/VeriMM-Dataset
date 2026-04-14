module top_module(SRAM,i,o);input  [0:15] SRAM;
input  [0:3] i;
output o;

tri [0:8] t1;
tri [0:4] t2;
tri [0:1] t3;

parameter mask = "ASDF";

assign t1[0] = i[0] ? SRAM[0] : SRAM[1];
assign t1[1] = i[0] ? SRAM[2] : SRAM[3];
assign t1[2] = i[0] ? SRAM[4] : SRAM[5];
assign t1[3] = i[0] ? SRAM[6] : SRAM[7];
assign t1[4] = i[0] ? SRAM[8] : SRAM[9];
assign t1[5] = i[0] ? SRAM[10] : SRAM[11];
assign t1[6] = i[0] ? SRAM[12] : SRAM[13];
assign t1[7] = i[0] ? SRAM[14] : SRAM[15];

assign t2[0] = i[1] ? t1[0] : t1[1];
assign t2[1] = i[1] ? t1[2] : t1[3];
assign t2[2] = i[1] ? t1[4] : t1[5];
assign t2[3] = i[1] ? t1[6] : t1[7];

assign t3[0] = i[2] ? t2[0] : t2[1];
assign t3[1] = i[2] ? t2[2] : t2[3];

assign o = i[3] ? t3[0] : t3[1];endmodule