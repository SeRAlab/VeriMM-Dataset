module top_module(out,clock,in);input in,clock;
output out;
reg out = 0;
reg temp = 0;
always @(posedge clock)
	begin
		if(in == 0)
			begin
				out = 0;
				temp = 0;
			end
		else if (in == 1 && out == 0 && temp == 0) 
			begin 
				out = 1;
				temp = 1;
			end
		else if (in == 1 && out == 1)
			begin
				out = 0;
			end
	end
endmodule