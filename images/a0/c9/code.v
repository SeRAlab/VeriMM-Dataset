module top_module(
	input wr,
	input [10:0] pos_x,
	input [10:0] pos_y,
	input [3:0] Red_in,
	input [3:0] Green_in,
	input [3:0] Blue_in,
	output [3:0] Red_out,
	output [3:0] Green_out,
	output [3:0] Blue_out
	);reg [11:0] mem [640:1][480:1];
	
	
	always @(posedge wr) begin
		if (wr == 1) begin
			mem[pos_x][pos_y][3:0] <= Red_in;
			mem[pos_x][pos_y][7:4] <= Green_in;
			mem[pos_x][pos_y][11:8] <= Blue_in;
		end
	end
	
	assign Red_out = mem[pos_x][pos_y][3:0];
	assign Green_out = mem[pos_x][pos_y][7:4];
	assign Blue_out = mem[pos_x][pos_y][11:8];endmodule