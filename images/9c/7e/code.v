module top_module(
	input clk, rst,
	input [1:0] a1, a2, a3, a4, a5, a6,
	input [3:0] off1, off2,
	input [31:5] din1,
	input [3:0] din2, din3,
	output reg [3:0] dout1, dout2,
	output reg [31:5] dout3
);reg [31:5] mem [0:3];

	always @(posedge clk) begin
		if (rst) begin
			mem[0] <= 0;
			mem[1] <= 0;
			mem[2] <= 0;
			mem[3] <= 0;
		end else begin
			mem[a1] <= din1;
			mem[a2][14:11] <= din2;
			mem[a3][5 + off1 +: 4] <= din3;
			dout1 <= mem[a4][12:9];
			dout2 <= mem[a5][5 + off2 +: 4];
			dout3 <= mem[a6];
		end
	end
endmodule