module top_module(key, c0x, d0x);input 	[1:64] key;
output 	[1:28] c0x, d0x;
wire 	[1:56] XX;

assign XX[1]=key[57]; assign  XX[2]=key[49]; assign  XX[3]=key[41]; assign  XX[4]=key[33]; assign  XX[5]=key[25]; assign  XX[6]=key[17]; assign  XX[7]=key[9];
assign XX[8]=key[1]; assign  XX[9]=key[58]; assign  XX[10]=key[50]; assign XX[11]=key[42]; assign XX[12]=key[34]; assign XX[13]=key[26]; assign XX[14]=key[18];
assign XX[15]=key[10]; assign XX[16]=key[2]; assign  XX[17]=key[59]; assign XX[18]=key[51]; assign XX[19]=key[43]; assign XX[20]=key[35]; assign XX[21]=key[27];
assign XX[22]=key[19]; assign XX[23]=key[11]; assign XX[24]=key[3]; assign  XX[25]=key[60]; assign XX[26]=key[52]; assign XX[27]=key[44]; assign XX[28]=key[36];
assign XX[29]=key[63]; assign XX[30]=key[55]; assign XX[31]=key[47]; assign XX[32]=key[39]; assign XX[33]=key[31]; assign XX[34]=key[23]; assign XX[35]=key[15];
assign XX[36]=key[7]; assign  XX[37]=key[62]; assign XX[38]=key[54]; assign XX[39]=key[46]; assign XX[40]=key[38]; assign XX[41]=key[30]; assign XX[42]=key[22];
assign XX[43]=key[14]; assign XX[44]=key[6]; assign  XX[45]=key[61]; assign XX[46]=key[53]; assign XX[47]=key[45]; assign XX[48]=key[37]; assign XX[49]=key[29];
assign XX[50]=key[21]; assign XX[51]=key[13]; assign XX[52]=key[5]; assign  XX[53]=key[28]; assign XX[54]=key[20]; assign XX[55]=key[12]; assign XX[56]=key[4];

assign c0x=XX[1:28]; assign d0x=XX[29:56];

endmodule