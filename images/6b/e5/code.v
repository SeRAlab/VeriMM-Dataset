module mux_5to1 (
	input [2:0] sel,
	input [9:0] in0,
	input [9:0] in1,
	input [9:0] in2,
	input [9:0] in3,
	input [9:0] in4,
	output reg [9:0] out
);

always @(*) begin
	case (sel)
		3'b000: out = in0;
		3'b001: out = in1;
		3'b010: out = in2;
		3'b011: out = in3;
		3'b100: out = in4;
		default: out = 10'd0;
	endcase
end

endmodule