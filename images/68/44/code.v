module top_module(output Z, input A, B);wire i;
	not(Z, i);
	nor(i, A, B);
endmodule