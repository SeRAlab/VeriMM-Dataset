module top_module(
	
	clk,
	reset,

	PIXEL_DATA,
	LINE_VALID,
	FRAME_VALID,

	ready,

	

	
	data,
	startofpacket,
	endofpacket,
	valid
);parameter DW = 9;




input						clk;
input						reset;

input			[DW: 0]	PIXEL_DATA;
input						LINE_VALID;
input						FRAME_VALID;

input						ready;




output reg	[DW: 0]	data;
output reg				startofpacket;
output reg			 	endofpacket;
output reg			 	valid;





wire				read_temps;


reg			[DW: 0]	io_pixel_data;
reg						io_line_valid;
reg						io_frame_valid;

reg						frame_sync;

reg			[DW: 0]	temp_data;
reg						temp_start;
reg						temp_end;
reg						temp_valid;








always @ (posedge clk)
begin
	io_pixel_data		<= PIXEL_DATA;
	io_line_valid		<= LINE_VALID;
	io_frame_valid		<= FRAME_VALID;
end


always @ (posedge clk)
begin
	if (reset)
	begin
		data				<= 'h0;
		startofpacket	<= 1'b0;
		endofpacket		<= 1'b0;
		valid				<= 1'b0;
	end
	else if (read_temps)
	begin
		data				<= temp_data;
		startofpacket	<= temp_start;
		endofpacket		<= temp_end;
		valid				<= temp_valid;
	end
	else if (ready)
		valid				<= 1'b0;
end


always @ (posedge clk)
begin
	if (reset)
		frame_sync 		<= 1'b0;
	else if (~io_frame_valid)
		frame_sync 		<= 1'b1;
	else if (io_line_valid & io_frame_valid)
		frame_sync 		<= 1'b0;
end

always @ (posedge clk)
begin
	if (reset)
	begin
		temp_data 		<= 'h0;
		temp_start		<= 1'b0;
		temp_end			<= 1'b0;
		temp_valid		<= 1'b0;
	end
	else if (read_temps)
	begin
		temp_data 		<= io_pixel_data;
		temp_start		<= frame_sync;
		temp_end			<= ~io_frame_valid;
		temp_valid		<= io_line_valid & io_frame_valid;
	end
	else if (~io_frame_valid)
	begin
		temp_end			<= ~io_frame_valid;
	end
end





assign read_temps = (ready | ~valid) & 
	((io_line_valid & io_frame_valid) | 
	 ((temp_start | temp_end) & temp_valid));





endmodule