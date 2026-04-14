module top_module(a,b,ci,s,co);input[3:0] a,b;
	input ci;
	output[3:0] s;
	output co;
	wire[3:0] G,P,C;
	assign G=a&b;
	assign P=a|b;
	assign C=G|P&{C[2:0],ci};
	assign s=P&(~G)^{C[2:0],ci};
	assign co=C[3];
endmodule