module top_module(sequencia_0, entrada_0, saida, sequencia_1, entrada_1);output reg saida;
	input [3:0]sequencia_0;
	input[3:0]entrada_0;
	input [3:0]sequencia_1;
	input[3:0]entrada_1;
	
	integer flag_0, flag_1;
	
	always@(*)
	begin
		flag_0 = (sequencia_0[0] != entrada_0[0])? 0 : (sequencia_0[1] != entrada_0[1])? 0 : (sequencia_0[2] != entrada_0[2])? 0 : (sequencia_0[3] != entrada_0[3])? 0 : 1;
		flag_1 = (sequencia_1[0] != entrada_1[0])? 0 : (sequencia_1[1] != entrada_1[1])? 0 : (sequencia_1[2] != entrada_1[2])? 0 : (sequencia_1[3] != entrada_1[3])? 0 : 1;
		
		saida = (flag_0 && flag_1)? 1: 0;
	end
	
	
endmodule