module top_module(
	input wire clk,

	input wire enable,
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,
	
	output reg out_title_1,
	output reg out_title_2
	);parameter[10:0] x1 = 11'd71;
parameter[10:0] x2 = 11'd520;
parameter[9:0] y1 = 10'd101;
parameter[9:0] y2 = 10'd140;

parameter[9:0] y3 = 10'd245;
parameter[9:0] y4 = 10'd284;

always @ (posedge clk)
	begin
	if (enable == 1)
	begin
		if ((gr_x[10:0]>=x1)&&(gr_x[10:0]<=x2)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_title_1 = 1;
			end
			else
				out_title_1 = 0;	
		if ((gr_x[10:0]>=x1)&&(gr_x[10:0]<=x2)&&(gr_y[9:0]>=y3)&&(gr_y[9:0]<=y4))
			begin
				out_title_2 = 1;
			end
			else
				out_title_2 = 0;	
	end
	else
	begin
		out_title_1 = 0;
		out_title_2 = 0;
	end	
	end
endmodule