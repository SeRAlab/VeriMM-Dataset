module top_module(c,d,k);input 	[1:28] c,d;
output 	[1:48] k;
wire 	[1:56] YY;

        assign YY[1:28]=c;         assign YY[29:56]=d;

        assign k[1]=YY[14];   assign k[2]=YY[17];   assign k[3]=YY[11];   assign k[4]=YY[24];   assign k[5]=YY[1];    assign k[6]=YY[5];
        assign k[7]=YY[3];    assign k[8]=YY[28];   assign k[9]=YY[15];   assign k[10]=YY[6];   assign k[11]=YY[21];  assign k[12]=YY[10];
        assign k[13]=YY[23];  assign k[14]=YY[19];  assign k[15]=YY[12];  assign k[16]=YY[4];   assign k[17]=YY[26];  assign k[18]=YY[8];
        assign k[19]=YY[16];  assign k[20]=YY[7];   assign k[21]=YY[27];  assign k[22]=YY[20];  assign k[23]=YY[13];  assign k[24]=YY[2];
        assign k[25]=YY[41];  assign k[26]=YY[52];  assign k[27]=YY[31];  assign k[28]=YY[37];  assign k[29]=YY[47];  assign k[30]=YY[55];
        assign k[31]=YY[30];  assign k[32]=YY[40];  assign k[33]=YY[51];  assign k[34]=YY[45];  assign k[35]=YY[33];  assign k[36]=YY[48];
        assign k[37]=YY[44];  assign k[38]=YY[49];  assign k[39]=YY[39];  assign k[40]=YY[56];  assign k[41]=YY[34];  assign k[42]=YY[53];
        assign k[43]=YY[46];  assign k[44]=YY[42];  assign k[45]=YY[50];  assign k[46]=YY[36];  assign k[47]=YY[29];  assign k[48]=YY[32];
endmodule