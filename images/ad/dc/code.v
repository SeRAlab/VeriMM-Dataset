module top_module(output reg [3:0] Sum, output reg Cout, input [3:0] A, B, input Cin);reg [4:0]	Tmp_Sum;

	always@(A, B, Cin) begin
		Tmp_Sum = A + B + Cin;
		Sum = A + B + Cin;
		if(Tmp_Sum > 9) begin
			Sum = Sum + 6;
			Cout = 1;
		end
		else begin
			Sum = Sum;
			Cout = 0;
		end
	end
endmodule