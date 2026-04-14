module top_module(d, c, newcrc);input [0:0] d;
	input [23:0] c;
	output [23:0] newcrc;
	
    assign newcrc[0] = d[0] ^ c[23];
	assign newcrc[1] = d[0] ^ c[0] ^ c[23];
	assign newcrc[2] = c[1];
	assign newcrc[3] = c[2];
	assign newcrc[4] = c[3];
	assign newcrc[5] = d[0] ^ c[4] ^ c[23];
	assign newcrc[6] = d[0] ^ c[5] ^ c[23];
	assign newcrc[7] = c[6];
	assign newcrc[8] = c[7];
	assign newcrc[9] = c[8];
	assign newcrc[10] = c[9];
	assign newcrc[11] = c[10];
	assign newcrc[12] = c[11];
	assign newcrc[13] = c[12];
	assign newcrc[14] = c[13];
	assign newcrc[15] = c[14];
	assign newcrc[16] = c[15];
	assign newcrc[17] = c[16];
	assign newcrc[18] = c[17];
	assign newcrc[19] = c[18];
	assign newcrc[20] = c[19];
	assign newcrc[21] = c[20];
	assign newcrc[22] = c[21];
	assign newcrc[23] = d[0] ^ c[22] ^ c[23];endmodule