module top_module(
    input [31:0] RD2,
    input [31:0] E_Forward,
    input [31:0] M_Forward,
    input [1:0] selet,
    output [31:0] rt_final
    );assign rt_final=(selet==0)?RD2:
			(selet==1)?E_Forward:
			(selet==2)?M_Forward:0;
	
	


endmodule