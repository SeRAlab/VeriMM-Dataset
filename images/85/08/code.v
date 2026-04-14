module top_module(
    input [31:0] M_reg_out,
    input [31:0] W_Forward,
    input selet,
    output [31:0] WD_final
    );assign WD_final=(selet==0)?M_reg_out:W_Forward;
	
	


endmodule