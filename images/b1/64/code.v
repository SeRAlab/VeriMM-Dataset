module top_module(E0,E1,S);input [15:0] E0,E1;
	output reg [15:0] S;
	
	always @(*)
		begin
			S = E0 + E1;
		end
endmodule