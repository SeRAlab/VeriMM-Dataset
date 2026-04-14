module top_module(
	
	input                 rc_ackn_rr    ,
	output                rc_ackn       ,

	
	output                p_prdy        ,
	output     [31:0]     p_data        ,
	output                c_crdy        ,
	output                c_cerr        ,
	
	input                 p_prdy_rr     ,
	input      [31:0]     p_data_rr     ,
	input                 c_crdy_rr     ,
	input                 c_cerr_rr     ,
	
	
	input                 is_reconfn
);assign rc_ackn    = (~is_reconfn)? 1'b1: rc_ackn_rr;
	assign p_prdy     = (~is_reconfn)? 1'b0: p_prdy_rr;
	assign p_data     = (~is_reconfn)? 32'h0: p_data_rr;
	assign c_crdy     = (~is_reconfn)? 1'b0: c_crdy_rr;
	
	
	
	
	assign c_cerr     = (~is_reconfn)? 1'b1: c_cerr_rr;

endmodule