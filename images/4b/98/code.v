module top_module(
	input binary,
	output reg [1:0] one_hot);

always @(*) begin
	case(binary)
		1'b0: one_hot = 2'b01;
		1'b1: one_hot = 2'b10;
		default: one_hot = 2'b00;
	endcase
end
endmodule