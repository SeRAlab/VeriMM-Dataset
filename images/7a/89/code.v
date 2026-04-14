module top_module(
    input [3:0]Ver,
    output reg [6:0]Salida7seg
    );always @(Ver)begin	
		case(Ver)
		
		7'b0000000: Salida7seg=7'b000_0001;
		7'b0000001: Salida7seg=7'b100_1111;
		7'b0000010: Salida7seg=7'b001_0010;
		7'b0000011: Salida7seg=7'b000_0110;
		7'b0000100: Salida7seg=7'b100_1100;
		7'b0000101: Salida7seg=7'b010_0100;
		7'b0000110: Salida7seg=7'b010_0000;
		7'b0000111: Salida7seg=7'b000_1111;
		7'b0001000: Salida7seg=7'b000_0000;
		7'b0001001: Salida7seg=7'b000_0100;
	
		7'b0001010: Salida7seg=7'b000_1000;
		7'b0001011: Salida7seg=7'b110_0000;
		7'b0001100: Salida7seg=7'b011_0001;
		7'b0001101: Salida7seg=7'b100_0010;
		7'b0001110: Salida7seg=7'b011_0000;
		7'b0001111: Salida7seg=7'b011_1000;

	
		default : Salida7seg=7'b000_0001;
		
		
		endcase
	end
endmodule