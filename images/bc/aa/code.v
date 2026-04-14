module top_module(s,a,b,chave1,chave2);output s;
	wire temp1;
	wire temp2;
	wire temp3;
	wire temp4;
	wire temp5;
	wire temp6;
	wire temp7;
	wire temp8;
	wire temp9;
	wire temp10;
	wire temp11;
	wire temp12;
	
	input a;
	input b;	 
	input chave1;
	input chave2;
	
	assign temp1 = (~(a^b));
	assign temp2 = a^b;
	assign temp3 = (~(a|b));
	assign temp4 = a|b;
	assign temp5 = temp1 & chave1;
	assign temp6 = temp3 & ~chave1;
	assign temp7 = temp2 & chave1;
	assign temp8 = temp4 & ~chave1;
	assign temp9 = temp5 | temp6;
	assign temp10 = temp7 | temp8;
	assign temp11 = temp9 & chave2;
	assign temp12 = temp10 | ~chave2;
	assign s = temp11 | temp12;endmodule