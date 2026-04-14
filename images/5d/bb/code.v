module mux4to1(
	input [7:0] d0,
	input [7:0] d1,
	input [7:0] d2,
	input [7:0] d3,
	input [1:0] sel,
	output reg [7:0] y);

	always @(*) begin
		case (sel)
			2'b00: y = d0;
			2'b01: y = d1;
			2'b10: y = d2;
			2'b11: y = d3;
			default: y = 8'b0;
		endcase
	end

endmodule