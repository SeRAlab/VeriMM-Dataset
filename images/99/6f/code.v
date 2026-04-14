module top_module(BCD, signo, caracter_terminacion, mensaje);input [15:0] BCD;
	input signo;
	input [7:0] caracter_terminacion;
	output reg [47:0]mensaje;
	
	

	parameter signo_positivo = 8'd33; 
	parameter signo_negativo = 8'd35; 
	
	

	wire [7:0] A,B,C,D;
	assign A = BCD[3:0] + 8'd48;
	assign B = BCD[7:4] + 8'd48;
	assign C = BCD[11:8] + 8'd48;
	assign D = BCD[15:12] + 8'd48;
	
	
	always @(*)
	begin
		case (signo)
			1'b0: 
				mensaje = {signo_negativo, A,B,C,D, caracter_terminacion};
			1'b1:
				mensaje = {signo_positivo, A,B,C,D, caracter_terminacion};
		endcase
	end
endmodule