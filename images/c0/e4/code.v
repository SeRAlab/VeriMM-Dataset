module jt51_sh1 #(parameter stages=32)
(
	input 	clk,
	input	en,
	input	ld,
	input	din,
   	output	drop
);
reg	[stages-1:0] shift;
assign drop = shift[0];
wire next = ld ? din : drop;
always @(posedge clk ) 
	if( en )
		shift <= {next, shift[stages-1:1]};
endmodule