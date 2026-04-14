module top_module(A, B, S, Y);parameter WIDTH = 0;

input [WIDTH-1:0] A, B;
input S;
output reg [WIDTH-1:0] Y;

always @* begin
	if (S)
		Y = B;
	else
		Y = A;
end

endmodule