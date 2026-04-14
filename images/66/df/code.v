module top_module(

	input  wire clk,

	input  wire d,

	output wire q

);reg trgp, trgn;

	assign q = trgp ^ trgn;

	always @(posedge clk)
	if( d!=q )
		trgp <= ~trgp;

	always @(negedge clk)
	if( d!=q )
		trgn <= ~trgn;

endmodule