module top_module(
	
	clk,
	reset,

	pixel_data_in,
	pixel_info_in,
	pixel_en_in,

	

	
	pixel_data_out,
	pixel_info_out,
	pixel_en_out
);input				clk;
input				reset;

input		[15:0]	pixel_data_in;
input		[1:0]	pixel_info_in;
input				pixel_en_in;




output	reg	[15:0]	pixel_data_out;
output	reg	[1:0]	pixel_info_out;
output	reg			pixel_en_out;





reg					keep_pixel;











always @(posedge clk)
	pixel_data_out <= pixel_data_in;

always @(posedge clk)
	pixel_info_out <= pixel_info_in;

always @(posedge clk)
	pixel_en_out <= (pixel_en_in & keep_pixel) | 
					(pixel_en_in & pixel_info_in[1]);


always @(posedge clk)
begin
	if (reset)
		keep_pixel <= 1'b0;
	else if (pixel_en_in & pixel_info_in[1])
		keep_pixel <= 1'b0;
	else if (pixel_en_in)
		keep_pixel <= keep_pixel ^ 1'b1;
end










endmodule