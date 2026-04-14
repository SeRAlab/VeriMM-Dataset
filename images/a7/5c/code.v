module top_module(CLK_I,rst, clk );input CLK_I,rst;

output reg clk;


parameter sys_clk = 100000000;	
parameter clk_out = 500;	

parameter max = sys_clk / (2*clk_out); 

reg [22:0]counter = 0; 

always@(posedge CLK_I or posedge rst) begin
	if(rst)
	begin
	   counter <= 0;
		clk <= 0;
	end
	else if (counter == max-1)
		begin
		counter <= 0;
		clk <= ~clk;
		end
	else
		begin
		counter <= counter + 1'd1;
		end
	end

endmodule