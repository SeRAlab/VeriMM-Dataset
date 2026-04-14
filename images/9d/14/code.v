module mux_6to1 (
	input [2:0] sel,
	input [11:0] in0,
	input [11:0] in1,
	input [11:0] in2,
	input [11:0] in3,
	input [11:0] in4,
	input [11:0] in5,
	output reg [11:0] out
);

always @(*) begin
	case (sel)
		3'b000: out = in0;
		3'b001: out = in1;
		3'b010: out = in2;
		3'b011: out = in3;
		3'b100: out = in4;
		3'b101: out = in5;
		default: out = 12'd0;
	endcase
end

endmodule