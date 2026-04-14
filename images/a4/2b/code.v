module top_module(inNum,outdt9,outdt8,outdt7,outdt6,outdt5,outdt4,outdt3,outdt2,outdt1,outdt0);input [31:0] inNum;
	output outdt9,outdt8,outdt7,outdt6,outdt5,outdt4,outdt3,outdt2,outdt1,outdt0;
	
	assign outdt9=inNum[9];
	assign outdt8=inNum[8];
	assign outdt7=inNum[7];
	assign outdt6=inNum[6];
	assign outdt5=inNum[5];
	assign outdt4=inNum[4];
	assign outdt3=inNum[3];
	assign outdt2=inNum[2];
	assign outdt1=inNum[1];
	assign outdt0=inNum[0];
	
endmodule