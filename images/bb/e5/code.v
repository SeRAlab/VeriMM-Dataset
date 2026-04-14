module top_module(pt, l0x, r0x);input	[1:64] pt;
output	[1:32] l0x, r0x;

assign l0x[1]=pt[58];         assign l0x[2]=pt[50];         assign l0x[3]=pt[42];         assign l0x[4]=pt[34];
assign l0x[5]=pt[26];         assign l0x[6]=pt[18];         assign l0x[7]=pt[10];         assign l0x[8]=pt[2];
assign l0x[9]=pt[60];         assign l0x[10]=pt[52];        assign l0x[11]=pt[44];        assign l0x[12]=pt[36];
assign l0x[13]=pt[28];        assign l0x[14]=pt[20];        assign l0x[15]=pt[12];        assign l0x[16]=pt[4];
assign l0x[17]=pt[62];        assign l0x[18]=pt[54];        assign l0x[19]=pt[46];        assign l0x[20]=pt[38];
assign l0x[21]=pt[30];        assign l0x[22]=pt[22];        assign l0x[23]=pt[14];        assign l0x[24]=pt[6];
assign l0x[25]=pt[64];        assign l0x[26]=pt[56];        assign l0x[27]=pt[48];        assign l0x[28]=pt[40];
assign l0x[29]=pt[32];        assign l0x[30]=pt[24];        assign l0x[31]=pt[16];        assign l0x[32]=pt[8];

assign r0x[1]=pt[57];         assign r0x[2]=pt[49];         assign r0x[3]=pt[41];         assign r0x[4]=pt[33];
assign r0x[5]=pt[25];         assign r0x[6]=pt[17];         assign r0x[7]=pt[9];          assign r0x[8]=pt[1];
assign r0x[9]=pt[59];         assign r0x[10]=pt[51];        assign r0x[11]=pt[43];        assign r0x[12]=pt[35];
assign r0x[13]=pt[27];        assign r0x[14]=pt[19];        assign r0x[15]=pt[11];        assign r0x[16]=pt[3];
assign r0x[17]=pt[61];        assign r0x[18]=pt[53];        assign r0x[19]=pt[45];        assign r0x[20]=pt[37];
assign r0x[21]=pt[29];        assign r0x[22]=pt[21];        assign r0x[23]=pt[13];        assign r0x[24]=pt[5];
assign r0x[25]=pt[63];        assign r0x[26]=pt[55];        assign r0x[27]=pt[47];        assign r0x[28]=pt[39];
assign r0x[29]=pt[31];        assign r0x[30]=pt[23];        assign r0x[31]=pt[15];        assign r0x[32]=pt[7];

endmodule