module mux2to1 (
	input clk,
	input a,
	input b,
	input sel,
	output reg y);

	always @(posedge clk) begin
		if (sel)
			y <= b;
		else
			y <= a;
	end
	
endmodule