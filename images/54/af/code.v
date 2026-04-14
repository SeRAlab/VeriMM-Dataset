module top_module(is_invincible, length, clock, reset, start);output is_invincible;
	
	input [1:0] length;
	input clock, reset, start;
	
	reg [51:0] count;

	always @(posedge clock, posedge reset)
		begin
			if (reset)
				count <= 52'd0;
			else if (start)
				count <= 52'd1;
			else if (count == (52'd50000000 * length - 1))
				count <= 52'd0;
			else if (count != 52'd0)
				count <= count + 52'd1;
		end
	
	assign is_invincible = (count == 52'd0) ? 1'd0 : 1'd1;endmodule