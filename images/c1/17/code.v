module dds_static
	#(
	parameter	integer							ACCUM_W			= 8,		
	parameter	[ACCUM_W-1:0]					INC_VAL			= 8		
	)
	(
	input			wire								clk_i,						
	input			wire								rst_i,						
	output		wire								clk_o							
	);
	reg					[ACCUM_W-1:0]			accum;
	always @ ( posedge clk_i or posedge rst_i ) begin
		if ( rst_i ) begin
			accum <= 'b0;
		end else begin
			accum <= accum + INC_VAL;
		end
	end
	assign clk_o = accum[ACCUM_W-1];
endmodule