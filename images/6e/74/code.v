module top_module(Q0,Q1,Q2,Q3,in,clock, reset);input in, reset, clock;
output reg Q0,Q1,Q2,Q3;

always @(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			Q3 <= 1'b0;
			Q2 <= 1'b0;
			Q1 <= 1'b0;
			Q0 <= 1'b0;
		end
			else
			begin
			Q3 <= in;
			Q2 <= Q3;
			Q1 <= Q2;
			Q0 <= Q1;
			end
	end
	
endmodule