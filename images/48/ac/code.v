module top_module(rst_i, clk_i, i, volume, o);input rst_i;
input clk_i;
input [15:0] i;
input [3:0] volume;
output [15:0] o;
reg [15:0] o;


wire [19:0] v1 = volume[0] ? i : 20'd0;
wire [19:0] v2 = volume[1] ? {i,1'b0} + v1: v1;
wire [19:0] v3 = volume[2] ? {i,2'b0} + v2: v2;
wire [19:0] vo = volume[3] ? {i,3'b0} + v3: v3;

always @(posedge clk_i)
	if (rst_i)
		o <= 16'b0;		
	else
		o <= vo[15:0];

endmodule