module mux4to1 (
	input clk,
	input a,
	input b,
	input c,
	input d,
	input [1:0] sel,
	output reg y);

	always @(posedge clk) begin
		case (sel)
			2'b00: y <= a;
			2'b01: y <= b;
			2'b10: y <= c;
			2'b11: y <= d;
		endcase
	end
	
endmodule