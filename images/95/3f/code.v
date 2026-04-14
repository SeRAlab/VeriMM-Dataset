module mux_4to1(
	input [1:0]sel,
	input in0,
	input in1,
	input in2,
	input in3,
	output reg y
);

	always @(*) begin
		case (sel)
			2'b00: y = in0;
			2'b01: y = in1;
			2'b10: y = in2;
			2'b11: y = in3;
			default: y = 1'b0;
		endcase
	end
	
endmodule