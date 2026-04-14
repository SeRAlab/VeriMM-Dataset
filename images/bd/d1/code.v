module top_module(A,B,X,Y,clock);input X;
	input clock;
	output A,B,Y;
	reg A;
	reg B;

always @ (posedge clock) begin
	A<=(X&A)|(X&B);
	B<=(X&~A);
	end
	
	assign Y = (A|B)&(~X);
	endmodule