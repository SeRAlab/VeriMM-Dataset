module top_module(
	input sys_clk,
	input sys_rst,

	output busy,

	input pipe_stb_i,
	output pipe_ack_o,
	input signed [11:0] x,
	input signed [11:0] y,
	input signed [17:0] tsx,
	input signed [17:0] tsy,
	input signed [17:0] tex,
	input signed [17:0] tey,

	output reg pipe_stb_o,
	input pipe_ack_i,
	output reg signed [11:0] x_f,
	output reg signed [11:0] y_f,
	output reg signed [17:0] tsx_f,
	output reg signed [17:0] tsy_f,
	output reg diff_x_positive,
	output reg [16:0] diff_x,
	output reg diff_y_positive,
	output reg [16:0] diff_y
);always @(posedge sys_clk) begin
	if(sys_rst)
		pipe_stb_o <= 1'b0;
	else begin
		if(pipe_ack_i)
			pipe_stb_o <= 1'b0;
		if(pipe_stb_i & pipe_ack_o) begin
			pipe_stb_o <= 1'b1;
			if(tex > tsx) begin
				diff_x_positive <= 1'b1;
				diff_x <= tex - tsx;
			end else begin
				diff_x_positive <= 1'b0;
				diff_x <= tsx - tex;
			end
			if(tey > tsy) begin
				diff_y_positive <= 1'b1;
				diff_y <= tey - tsy;
			end else begin
				diff_y_positive <= 1'b0;
				diff_y <= tsy - tey;
			end
			x_f <= x;
			y_f <= y;
			tsx_f <= tsx;
			tsy_f <= tsy;
		end
	end
end

assign pipe_ack_o = ~pipe_stb_o | pipe_ack_i;

assign busy = pipe_stb_o;

endmodule