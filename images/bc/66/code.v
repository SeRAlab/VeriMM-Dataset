module mux_4to1_4bit(
	input [3:0] a,
	input [3:0] b,
	input [3:0] c,
	input [3:0] d,
	input [1:0] sel,
	output reg [3:0] y
);

	always @(*) begin
		case (sel)
			2'b00: y = a;
			2'b01: y = b;
			2'b10: y = c;
			2'b11: y = d;
			default: y = 4'b0000;
		endcase
	end

endmodule