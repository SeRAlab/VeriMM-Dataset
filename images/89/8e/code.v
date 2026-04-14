module top_module(
	
	clk,
	reset,

	stream_in_data,
	stream_in_startofpacket,
	stream_in_endofpacket,
	stream_in_valid,

	stream_out_ready,
	
	

	
	stream_in_ready,

	stream_out_data,
	stream_out_startofpacket,
	stream_out_endofpacket,
	stream_out_valid
);parameter DW	=  15; 




input						clk;
input						reset;

input			[DW: 0]	stream_in_data;
input						stream_in_startofpacket;
input						stream_in_endofpacket;
input						stream_in_valid;

input						stream_out_ready;




output					stream_in_ready;

output reg	[DW: 0]	stream_out_data;
output reg				stream_out_startofpacket;
output reg				stream_out_endofpacket;
output reg				stream_out_valid;







wire						internal_ready;


reg			[DW: 0]	internal_data;
reg						internal_startofpacket;
reg						internal_endofpacket;
reg						internal_valid;











always @(posedge clk)
begin
	if (reset)
	begin
		stream_out_data				<=  'h0;
		stream_out_startofpacket	<= 1'b0;
		stream_out_endofpacket		<= 1'b0;
		stream_out_valid				<= 1'b0;
	end
	else if (stream_in_ready & stream_in_valid)
	begin
		stream_out_data				<= internal_data;
		stream_out_startofpacket	<= internal_startofpacket;
		stream_out_endofpacket		<= internal_endofpacket | stream_in_startofpacket;
		stream_out_valid				<= internal_valid;
	end
	else if (stream_out_ready)
		stream_out_valid				<= 1'b0;
end


always @(posedge clk)
begin
	if (reset)
	begin
		internal_data					<=  'h0;
		internal_startofpacket		<= 1'b0;
		internal_endofpacket			<= 1'b0;
		internal_valid					<= 1'b0;
	end
	else if (stream_in_ready & stream_in_valid)
	begin
		internal_data					<= stream_in_data;
		internal_startofpacket		<= stream_in_startofpacket;
		internal_endofpacket			<= stream_in_endofpacket;
		internal_valid					<= stream_in_valid;
	end
end



assign stream_in_ready = stream_out_ready | ~stream_out_valid;






endmodule