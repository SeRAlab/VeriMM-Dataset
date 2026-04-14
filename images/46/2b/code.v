module top_module(
	input wire [31:0] in1,
	input wire [31:0] in2,
	input wire control,
	output reg [31:0] out
	);always @* begin
	case (control)
		1'b0: out <= in1;
		1'b1: out <= in2;
	endcase
end

endmodule