module top_module(
	input [3:0] one_hot,
	output reg [1:0] binary);always @(*) begin
	case(one_hot)
		4'b0001: binary = 2'b00;
		4'b0010: binary = 2'b01;
		4'b0100: binary = 2'b10;
		4'b1000: binary = 2'b11;
		default: binary = 2'b00;
	endcase
end
endmodule