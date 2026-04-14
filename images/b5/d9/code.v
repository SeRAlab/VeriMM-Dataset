module top_module(
unidade,
dezena,
D,
U
);input [3:0] unidade, dezena;
output reg [6:0] U, D;

always @ (dezena or unidade) begin
	case (dezena)
			4'b0000 : D = 7'b0000001;
			4'b0001 : D = 7'b1001111;
			4'b0010 : D = 7'b0010010;
			4'b0011 : D = 7'b0000110;
			4'b0100 : D = 7'b1001100;
			4'b0101 : D = 7'b0100100;
			4'b0110 : D = 7'b0100000;
			4'b0111 : D = 7'b0001111;
			4'b1000 : D = 7'b0000000;
			4'b1001 : D = 7'b0000100;
			default : D = 7'b1111111;
	endcase
	
	case (unidade)
			4'b0000 : U = 7'b0000001;
			4'b0001 : U = 7'b1001111;
			4'b0010 : U = 7'b0010010;
			4'b0011 : U = 7'b0000110;
			4'b0100 : U = 7'b1001100;
			4'b0101 : U = 7'b0100100;
			4'b0110 : U = 7'b0100000;
			4'b0111 : U = 7'b0001111;
			4'b1000 : U = 7'b0000000;
			4'b1001 : U = 7'b0000100;
			default : U = 7'b1111111;
	endcase
end



endmodule