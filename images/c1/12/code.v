module vector_sr
	#(
	parameter	integer					REGS					= 4,			
	parameter	integer					DATA_W				= 2,			
	parameter	[DATA_W-1:0]			RESET_VAL			= 0			
	)
	(
	input		wire							clk_i,								
	input		wire							rst_i,								
	input		wire	[DATA_W-1:0]		data_i,								
	output	wire	[DATA_W-1:0]		data_o								
	);
	genvar									i;
	generate
		if ( REGS == 0 ) begin
			assign data_o = data_i;
		end else begin
			reg [DATA_W-1:0] stage[0:REGS-1];
			for ( i=0; i<REGS; i=i+1 ) begin : loop
				always @ ( posedge clk_i or posedge rst_i ) begin
					if ( rst_i ) begin
						stage[i] <= RESET_VAL;
					end else begin
						stage[i] <= ( i == REGS-1 ) ? data_i : stage[i+1];
					end
				end
			end  
			assign data_o = stage[0];
		end
	endgenerate
endmodule