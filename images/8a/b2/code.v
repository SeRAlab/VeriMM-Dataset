module top_module(
	
	clk,
	reset,

	stream_data,
	stream_startofpacket,
	stream_endofpacket,
	stream_empty,
	stream_valid,

	master_waitrequest,
	
	

	
	stream_ready,

	master_write,
	master_writedata,

	inc_address,
	reset_address
);parameter DW	=  15; 
parameter EW	=   0; 

parameter MDW	=  15; 




input						clk;
input						reset;

input			[DW: 0]	stream_data;
input						stream_startofpacket;
input						stream_endofpacket;
input			[EW: 0]	stream_empty;
input						stream_valid;

input						master_waitrequest;
	



output					stream_ready;

output					master_write;
output		[MDW:0]	master_writedata;

output					inc_address;
output					reset_address;









reg			[DW: 0]	temp_data;
reg						temp_valid;













always @(posedge clk)
begin
	if (reset)
	begin
		temp_data	<=  'h0;
		temp_valid	<= 1'b0;
	end
	else if (stream_ready)
	begin
		temp_data	<= stream_data;
		temp_valid	<= stream_valid;
	end
end



assign stream_ready		= ~temp_valid | ~master_waitrequest;

assign master_write		= temp_valid;
assign master_writedata	= temp_data;

assign inc_address		= stream_ready & stream_valid;
assign reset_address		= inc_address & stream_startofpacket;






endmodule