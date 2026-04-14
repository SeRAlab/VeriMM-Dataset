module top_module(entrada, saida);input [1:0]entrada;
output reg [0:6]saida;

always@(*)
begin
	case(entrada)
		4'b00: saida = 7'b1000000;
		4'b01: saida = 7'b1111001;
		4'b10: saida = 7'b0100100;
		4'b11: saida = 7'b0110000;
		default: saida = 7'b0111111;
	endcase;
end

endmodule