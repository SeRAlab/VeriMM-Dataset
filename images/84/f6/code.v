module top_module(addr, cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, cs_);input [31:0] addr;
	input cs_;
	output cs0;
	output cs1;
	output cs2;
	output cs3;
	output cs4;
	output cs5;
	output cs6;
	output cs7;
	
reg cs0 = 1;
reg cs1 = 1;
reg cs2 = 1;
reg cs3 = 1;
reg cs4 = 1;
reg cs5 = 1;
reg cs6 = 1;
reg cs7 = 1;
	
always @(*)
	case( { addr[31:22], cs_ } )
		11'h0:		{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1 };
		11'h2:		{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1 };
		11'h4:		{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1 };
		11'h6:		{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1 };
		11'h8:		{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1 };
		11'ha:		{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1 };
		11'hc:		{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1 };
		11'he:		{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0 };		
		
		default:	{ cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7 } <= { 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1 };
	endcase
	
endmodule