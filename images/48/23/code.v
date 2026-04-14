module top_module(A, B, S, Y);parameter WIDTH = 0;
parameter S_WIDTH = 0;

input [WIDTH-1:0] A;
input [WIDTH*S_WIDTH-1:0] B;
input [S_WIDTH-1:0] S;
output reg [WIDTH-1:0] Y;

integer i;
reg found_active_sel_bit;

always @* begin
	Y = A;
	found_active_sel_bit = 0;
	for (i = 0; i < S_WIDTH; i = i+1)
		if (S[i]) begin
			Y = found_active_sel_bit ? 'bx : B >> (WIDTH*i);
			found_active_sel_bit = 1;
		end
end

endmodule