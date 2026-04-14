module top_module(l,r,ct);input	[1:32] l,r;
output	[1:64] ct;

	assign ct[1]=r[8];	assign ct[2]=l[8];	assign ct[3]=r[16];	assign ct[4]=l[16];	assign ct[5]=r[24];	assign ct[6]=l[24];	assign ct[7]=r[32];	assign ct[8]=l[32];
	assign ct[9]=r[7];	assign ct[10]=l[7];	assign ct[11]=r[15];	assign ct[12]=l[15];	assign ct[13]=r[23];	assign ct[14]=l[23];	assign ct[15]=r[31];	assign ct[16]=l[31];
	assign ct[17]=r[6];	assign ct[18]=l[6];	assign ct[19]=r[14];	assign ct[20]=l[14];	assign ct[21]=r[22];	assign ct[22]=l[22];	assign ct[23]=r[30];	assign ct[24]=l[30];
	assign ct[25]=r[5];	assign ct[26]=l[5];	assign ct[27]=r[13];	assign ct[28]=l[13];	assign ct[29]=r[21];	assign ct[30]=l[21];	assign ct[31]=r[29];	assign ct[32]=l[29];
	assign ct[33]=r[4];	assign ct[34]=l[4];	assign ct[35]=r[12];	assign ct[36]=l[12];	assign ct[37]=r[20];	assign ct[38]=l[20];	assign ct[39]=r[28];	assign ct[40]=l[28];
	assign ct[41]=r[3];	assign ct[42]=l[3];	assign ct[43]=r[11];	assign ct[44]=l[11];	assign ct[45]=r[19];	assign ct[46]=l[19];	assign ct[47]=r[27];	assign ct[48]=l[27];
	assign ct[49]=r[2];	assign ct[50]=l[2];	assign ct[51]=r[10];	assign ct[52]=l[10];	assign ct[53]=r[18];	assign ct[54]=l[18];	assign ct[55]=r[26];	assign ct[56]=l[26];
	assign ct[57]=r[1];	assign ct[58]=l[1];	assign ct[59]=r[9];	assign ct[60]=l[9];	assign ct[61]=r[17];	assign ct[62]=l[17];	assign ct[63]=r[25];	assign ct[64]=l[25];

endmodule