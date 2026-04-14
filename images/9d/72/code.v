module top_module(
	input clk, enable, reset,
	 input [1:0] count_up,
	output reg [WIDTH-1:0] count
);parameter WIDTH = 11;
	parameter board_width=80;
    parameter x_total=800;

	reg [WIDTH-1:0] direction;
	reg [WIDTH-1:0] limit;

	
	always @ (posedge clk or posedge reset)
	begin
		if (reset)
			count <= 0;
		else if (enable == 1'b1)
		begin
			if (count_up==2'b10)
			begin
				direction <= 2;
				limit <= x_total-board_width;	 
			end
			else 
			begin
			if (count_up==2'b01)
			     begin
				direction <= -2; 
				limit <= {WIDTH{1'b0}};
				end
			else
			    direction <= 0;
			end

			if (count != limit)
				count <= count + direction;
		end
	end

endmodule