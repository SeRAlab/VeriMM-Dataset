module dq_ram_infer
	#(
	parameter		integer						REG_OUT			= 1,  
	parameter		integer						DATA_W			= 16,
	parameter		integer						ADDR_W			= 8,
	parameter										RD_MODE 			= "MEM_DATA"  
	)
	(
	input			wire								clk_i,			
	input			wire	[ADDR_W-1:0]			addr_i,			
	input			wire								wr_i,				
	input			wire	[DATA_W-1:0]			data_i,			
	output		wire	[DATA_W-1:0]			data_o			
	);
	localparam		integer						CAPACITY			= 2**ADDR_W;  
	reg					[DATA_W-1:0]			ram[0:CAPACITY-1];  
	reg					[DATA_W-1:0]			data;	
	always @ ( posedge clk_i ) begin
		if ( wr_i ) begin
			ram[addr_i] <= data_i;
		end
	end
	always @ ( posedge clk_i ) begin
		if ( wr_i & RD_MODE == "WR_DATA" ) begin
			data <= data_i;
		end else begin
			data <= ram[addr_i];
		end
	end
	generate
		if ( REG_OUT == 1 ) begin
			reg [DATA_W-1:0] data_r;
			always @ ( posedge clk_i ) begin
				data_r <= data;
			end
			assign data_o = data_r;
		end else begin
			assign data_o = data;
		end
	endgenerate
endmodule