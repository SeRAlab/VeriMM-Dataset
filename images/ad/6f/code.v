module top_module(clk, enable, fb_addr, hcount, vcount, rgb, sram_data, sram_addr, sram_read, sram_rdy);input clk, enable;
	input [31:0] fb_addr;
	input [10:0] hcount, vcount;
	output [7:0] rgb;
	input [31:0] sram_data;
	output [31:0] sram_addr;
	output sram_read;
	input sram_rdy;

	
	reg [31:0] buffer [159:0]; 

	reg [31:0] vcount_current = 0;
	reg [9:0] pos = 640;

	
	assign rgb = 
		hcount[1:0] == 2'b00 ? buffer[(hcount-1)>>2][7:0] :
		hcount[1:0] == 2'b01 ? buffer[hcount>>2][31:24] :
		hcount[1:0] == 2'b10 ? buffer[hcount>>2][23:16]  :
		hcount[1:0] == 2'b11 ? buffer[hcount>>2][15:8] : 0;

	assign sram_addr = fb_addr + (vcount_current * 640) + pos;
	assign sram_read = (pos != 640 && enable);

	always @(posedge clk) begin
		if (vcount_current != vcount) begin 
			vcount_current <= vcount;
			pos <= 0;
		end
		if (pos != 640 && sram_rdy) begin
			pos <= pos + 4;
			buffer[pos>>2] <= sram_data;
		end
	end
endmodule