module pipe
	#(
	parameter	integer					DEPTH					= 4,			
	parameter	integer					WIDTH					= 2,			
	parameter	[WIDTH-1:0]				RESET_VAL			= 0			
	)
	(
	input		wire							clk_i,								
	input		wire							rst_i,								
	input		wire	[WIDTH-1:0]			data_i,								
	output	wire	[WIDTH-1:0]			data_o								
	);
	genvar									i;
	generate
		if ( DEPTH == 0 ) begin
			assign data_o = data_i;
		end else begin
			reg [WIDTH-1:0] stage[0:DEPTH-1];
			for ( i=0; i<DEPTH; i=i+1 ) begin : loop
				always @ ( posedge clk_i or posedge rst_i ) begin
					if ( rst_i ) begin
						stage[i] <= RESET_VAL;
					end else begin
						stage[i] <= ( i == DEPTH-1 ) ? data_i : stage[i+1];
					end
				end
			end  
			assign data_o = stage[0];
		end
	endgenerate
endmodule