module top_module(out, in0, in1, s0);output reg [31:0] out;
input [31:0] in0, in1;
input s0;

always @(*) begin
	case(s0)
	1'b0: out = in0;
	1'b1: out = in1;
	default: out = 32'hxxxxxxxx;
	endcase
end
endmodule