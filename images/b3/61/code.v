module top_module (
  input sel,
  input [3:0] a,
  input [3:0] b,
  output reg [3:0] y);always @(*) begin
		if (sel)
			y <= b;
		else
			y <= a;
	end
endmodule