module top_module( 
	input clk_i,
	input reset_i,
	input [5:0] addr_i,	
	input write_i,
	input read_i,
	input [31:0] data_i,
	output reg [31:0] data_o,
	output [79:0] keys
	);reg [79:0] keys_r = 80'hffffffffffffffff;

	
	assign keys = keys_r;
	
	
	
	
	
	
	
	always @(negedge clk_i)
	if( !reset_i ) begin
		if( write_i ) begin
			case(addr_i)
				0:	keys_r[31:0] <= data_i;
				1:	keys_r[63:32] <= data_i;
				2:	keys_r[79:64] <= data_i[15:0];
			endcase
		end
		if( read_i ) begin
			case(addr_i)
				0:	data_o <= keys_r[31:0];
				1:	data_o <= keys_r[63:32];
				2:	data_o <= {16'hff,keys_r[79:64]};
			endcase
		end
	end
endmodule