module top_module(clk,
						Address, D_In,
						dm_cs,dm_wr,dm_rd,
						D_Out);input 				clk;
	input 	[31:0] 	D_In;
	input 	[11:0]  Address;
	input					dm_cs,dm_wr,dm_rd;

	output	[31:0]	D_Out;
	
	reg		 [7:0]	M	[4095:0];
	

	
	
	
	always@(posedge clk)
		if(dm_wr & dm_cs) {M[Address],M[Address+1],M[Address+2],M[Address+3]} = D_In;
	
	
	
	
	assign D_Out =(dm_rd&dm_cs)? {M[Address],M[Address+1],M[Address+2],M[Address+3]}:
											32'bz;
	
endmodule