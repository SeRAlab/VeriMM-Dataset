module top_module(
	input			rst,

	input	[23:0]	lcd_data_i,
	input			lcd_pclk_i,
	input			lcd_vsync_i,
	input			lcd_hsync_i,
	input			lcd_de_i,

	output			lcd_clk_o,
	output	[11:0]	lcd_x_o,
	output	[11:0]	lcd_y_o,
	output	[23:0]	lcd_data_o,
	output			lcd_data_valid_o
);reg		[11:0]	lcd_x_q;
reg		[11:0]	lcd_y_q;
reg		[23:0]	lcd_data_q;
reg				lcd_hsync_q;
reg				lcd_vsync_q;
reg				lcd_de_q;

assign			lcd_clk_o = lcd_pclk_i;
assign			lcd_x_o = lcd_x_q;
assign			lcd_y_o = lcd_y_q;
assign			lcd_data_o = lcd_data_q;
assign			lcd_data_valid_o = lcd_de_q;

wire			lcd_hsync_end = (lcd_hsync_i == 0) && (lcd_hsync_q == 1);
wire			lcd_vsync_end = (lcd_vsync_i == 1) && (lcd_vsync_q == 0);

always @(posedge lcd_pclk_i) begin
	if (rst) begin
		lcd_x_q <= 0;
		lcd_y_q <= 0;
		lcd_data_q <= 0;
		lcd_hsync_q <= 0;
		lcd_vsync_q <= 0;
		lcd_de_q <= 0;
	end
	else begin
		lcd_hsync_q <= lcd_hsync_i;
		lcd_vsync_q <= lcd_vsync_i;
		lcd_de_q <= lcd_de_i;

		if (lcd_de_i) begin
			lcd_data_q <= lcd_data_i;
		end else begin
			lcd_data_q <= 0;
		end

		if (lcd_vsync_end) begin
			lcd_y_q <= 0;
		end else begin
			if (lcd_hsync_end) begin
				lcd_y_q <= lcd_y_q + 12'h1;
			end
		end

		if (lcd_hsync_end) begin
			lcd_x_q <= 0;
		end else begin
			if (lcd_de_q) begin
				lcd_x_q <= lcd_x_q + 12'h1;
			end
		end
	end
end

endmodule