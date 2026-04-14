module top_module(
	input wire clk,

	input wire [1:0]clcount,	
	input wire enable,
	input wire [9:0]tor_x,
	input wire [8:0]tor_y,
	
	output reg t_yes,
	output reg t_no	
	);parameter[9:0] x1 = 11'd210;
parameter[9:0] x2 = 11'd288;
parameter[8:0] y1 = 11'd301;
parameter[8:0] y2 = 11'd380;

parameter[9:0] x3 = 11'd406;
parameter[9:0] x4 = 11'd495;


always @ (posedge clk)
	begin
	if (enable == 1)
	begin
		if (clcount == 1)
		begin
			if ((tor_x[9:0]>=x1[9:0])&&(tor_x[9:0]<=x2)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
				begin
					t_yes = 1;
				end
				else
					t_yes = 0;
			if ((tor_x[9:0]>=x3[9:0])&&(tor_x[9:0]<=x4)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
				begin
					t_no = 1;
				end
				else
					t_no = 0;		
		end
		else
		begin
			t_yes = 0;
			t_no = 0;	
		end
	end
	else
	begin
		t_yes = 0;
		t_no = 0;		
	end
	end
endmodule