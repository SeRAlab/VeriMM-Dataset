module top_module(entrada,saida);input[4:0]entrada;
	output reg[3:0]saida;

	always@(*)
	begin
		case(entrada)
			5'b00000: saida=4'b1001;
			5'b00001: saida=4'b0000;
			5'b00010: saida=4'b1000;
			5'b00011: saida=4'b0011;
			5'b00100: saida=4'b0111;
			5'b00101: saida=4'b0100;
			5'b00110: saida=4'b0100;
			5'b00111: saida=4'b0011;
			5'b01000: saida=4'b0101;
			5'b01001: saida=4'b1111;
			5'b01010: saida=4'b1111;
			5'b01011: saida=4'b1111;
			5'b01100: saida=4'b1111;
			5'b01101: saida=4'b1111;
			5'b01110: saida=4'b1111;
			5'b01111: saida=4'b1111;
			5'b10000: saida=4'b1111;
			5'b10001: saida=4'b1111;
			default: saida=4'b1111;
		endcase
	end
endmodule