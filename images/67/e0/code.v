module top_module(
	input wire clk,

	input wire switch,
	input wire [1:0]clcount,
	input wire [7:0]enable,

	input wire [9:0]tor_x,
	input wire [8:0]tor_y,

	
	output reg outtd
	
	);parameter[9:0] x1 = 11'd10;
parameter[9:0] x2 = 11'd110;
parameter[8:0] y1 = 11'd10;
parameter[8:0] y2 = 11'd80;


always @ (posedge clk)
	begin
		
		if (clcount == 1) 
		begin
			if ((tor_x[9:0]>=x1)&&(tor_x[9:0]<=x2)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
					outtd = 1;
				else
					outtd = 0;
		end
		else
			outtd = 0;
	end	
endmodule