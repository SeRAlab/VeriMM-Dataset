module top_module(
input wire [7:0] a,
output reg [7:0] b,
input EN
);reg [7:0] s1;


always @ (*)
	if (EN ==1)begin
	s1 <= ~a;
	b <= s1 +1'b1;
	end
	else begin
	s1 <= 0;
	b <= 0;
	end


endmodule