module top_module(
	
	clk,
	reset,

	
	stream_in_data,
	stream_in_startofpacket,
	stream_in_endofpacket,
	stream_in_valid,
	stream_in_ready,

	
	stream_out_ready,
	stream_out_data,
	stream_out_startofpacket,
	stream_out_endofpacket,
	stream_out_valid
);parameter CW		= 29;			
parameter DW		= 39;			

parameter COLOR	= 30'd0;		
parameter ALPHA	= 10'd0;		




input						clk;
input						reset;


input			[DW: 0]	stream_in_data;
input						stream_in_startofpacket;
input						stream_in_endofpacket;
input						stream_in_valid;
output					stream_in_ready;


input						stream_out_ready;
output reg	[DW: 0]	stream_out_data;
output reg				stream_out_startofpacket;
output reg				stream_out_endofpacket;
output reg				stream_out_valid;







wire			[DW: 0]	converted_data;













always @(posedge clk)
begin
	if (reset)
	begin
		stream_out_data				<=  'b0;
		stream_out_startofpacket	<= 1'b0;
		stream_out_endofpacket		<= 1'b0;
		stream_out_valid				<= 1'b0;
	end
	else if (stream_out_ready | ~stream_out_valid)
	begin
		stream_out_data				<= converted_data;
		stream_out_startofpacket	<= stream_in_startofpacket;
		stream_out_endofpacket		<= stream_in_endofpacket;
		stream_out_valid				<= stream_in_valid;
	end
end






assign stream_in_ready = stream_out_ready | ~stream_out_valid;


assign converted_data = (stream_in_data[CW:0] == COLOR) ?
									{ALPHA, stream_in_data[CW:0]} :
									stream_in_data;




endmodule