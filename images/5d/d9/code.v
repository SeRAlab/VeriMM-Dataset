module top_module(input inclk,
						 input ena,
					    output reg clk = 1);parameter maxcount=28'd5000000;
reg [27:0] count=28'd0;

always @ (posedge inclk)
	begin
	if (ena)
		begin
			if (count==maxcount)
				begin
				clk<=~clk;
				count<=28'd0;
				end
			else
				begin
				count<=count+1;
				end
		end
	else
		begin
		clk<=0;
		end
	end

endmodule