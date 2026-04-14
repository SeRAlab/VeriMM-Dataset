module top_module(D,B,x,y,z);output D,B;
	input x,y,z;

	

	assign D=(~x&&~y&&z)||(~x&&y&&~z)||(x&&~y&&~z)||(x&&y&&z);
	assign B=(~x&&y)||(~x&&z)||(y&&z);

endmodule