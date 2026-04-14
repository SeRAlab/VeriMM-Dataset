module top_module( 
		input 			clk_i,
		input 			enable_i,	
		input 			d_avail_i,	
		input [7:0]		data_i,
		output [15:0] 	adr_o,		
		output [7:0]	data_o,
		output 			wr_o,			
		output			rd_o,			
		output			n_reset_o	
	);reg [2:0] 	state = 3'd0;
	reg [15:0] 	address = 0;
	reg 			mem_wr = 0;
	reg			inbound_rd = 0, d_avail = 0;
	reg			n_reset = 1;
	
	
	assign rd_o = inbound_rd;
	assign data_o = data_i;
	assign n_reset_o = n_reset;

	assign adr_o = address;
	assign wr_o = mem_wr;
	
	
	always @( posedge clk_i ) d_avail <= d_avail_i;		
	
	
	always @(negedge clk_i)
	begin
		case (state)
			0 :begin
				address <= 16'd0;
				mem_wr <= 0;
				inbound_rd <= 0;
				if( enable_i ) state <= 3'd1;
			end
			1 :begin
				n_reset <= 0;
				state <= 3'd2;
				end
			2 :begin
				n_reset <= 1;			
				state <= 3'd3;			
				end
			3 :begin
				if( !enable_i ) 
					state <= 3'd0;
				else
					if( d_avail )
						state <= 3'd4;
			end
			4 :begin
				inbound_rd <= 1'b1;	
				state <= 3'd5;
			end
			5 :begin
				inbound_rd <= 1'b0;
				mem_wr <= 1'b1;		
				state <= 3'd6;
			end
			6 :begin
				mem_wr <= 1'd0;
				state <= 3'd7;
			end
			7 :begin
				address <= address + 1'b1;
				state <= 3'd3;
			end
			default:
				state <= 3'd0;
		endcase
	end
	
	
endmodule