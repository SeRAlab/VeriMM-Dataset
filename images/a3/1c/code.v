module top_module(input [3:0] input_bits, output reg [1:0] output_bits);always @(*)
begin
	case(input_bits[1:0])
		2'b00: output_bits = input_bits[3];
		2'b01: output_bits = input_bits[2];
		2'b10: output_bits = input_bits[1];
		2'b11: output_bits = input_bits[0];
	endcase
end

endmodule