module top_module(clk, rst_n, note_div, au_left, au_right);output [15:0]au_left, au_right;
	input clk, rst_n;
	input [19:0]note_div;
	
	reg [19:0] clk_cnt_next, clk_cnt;
	reg b_clk, b_clk_next;

	always@(posedge clk or negedge rst_n)
		if(~rst_n) begin
			clk_cnt <= 20'd0;
			b_clk <= 0;
		end
		else begin
			clk_cnt <= clk_cnt_next;
			b_clk <= b_clk_next;
		end
	
	always@(*)
		if(clk_cnt == note_div) begin
			clk_cnt_next = 20'd0;
			b_clk_next = ~b_clk;
		end
		else begin
			clk_cnt_next = clk_cnt + 20'b1;
			b_clk_next = b_clk;
		end

	assign au_left = (b_clk == 1'b0) ? 16'h8005 : 16'h7FFF;
	assign au_right = (b_clk == 1'b0) ? 16'h8005 : 16'h7FFF;
endmodule