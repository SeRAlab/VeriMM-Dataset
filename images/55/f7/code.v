module top_module(entrada0, entrada1, sinal, saida);input [7:0]entrada1, entrada0;
	input sinal;
	output reg [7:0] saida;
	
	always @(*) begin
		if(sinal) begin
			saida = entrada1;
		end
		else begin 
			saida = entrada0;
		end
	end
endmodule