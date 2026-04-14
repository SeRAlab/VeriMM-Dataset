module SQM_LOG(
	input [3:0]din,
	output reg [11:0]dout );
always @(din)
	case (din)
		0: dout=0;
		1: dout=16;
		2: dout=19;
		3: dout=32;
		4: dout=39;
		5: dout=64;
		6: dout=78;
		7: dout=128;
		8: dout=155;
		9: dout=256;
	 10: dout=310;
	 11: dout=512;
	 12: dout=621;
	 13: dout=1024;
	 14: dout=1448;
	 15: dout=2048;
	endcase
endmodule