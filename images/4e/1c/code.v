module mux_3to1 (
	input [1:0] sel,
	input [5:0] in0,
	input [5:0] in1,
	input [5:0] in2,
	output reg [5:0] out
);

always @(*) begin
	case (sel)
		2'b00: out = in0;
		2'b01: out = in1;
		2'b10: out = in2;
		default: out = 6'd0;
	endcase
end

endmodule