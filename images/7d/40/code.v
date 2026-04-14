module top_module(A,B,S,F);input A, B, S;
	output reg F;
	
	always @(A,B,S) begin
		if(S == 1) begin
			F = A;
		end
		else	begin
			F = B;
		end
	end
	
endmodule