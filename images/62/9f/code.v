module top_module(S, Cout, A, B, C);output reg [3:0] S;
	output reg Cout;
	input [3:0] A, B;
	input C;

	always @ (A, B, C) begin
		if (C == 0) begin
			S = A + B;
			Cout = (S[4] == 1) ? 1 : 0;
		end else begin
			S = A - B;
			Cout = (S[4] == 1) ? 0 : 1;
		end
	end
endmodule