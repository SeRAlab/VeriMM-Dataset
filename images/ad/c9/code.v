module top_module(q,qbar,clock,data);output q, qbar;
	input clock, data;
	wire nand1, nand2;
	wire databar;
	not #1	 (databar,data);
	nand #1 (nand1,clock, data);
	nand #1 (nand2,clock, databar);
	nand #1 (qbar,nand2,q);
	nand #1 (q,nand1,qbar);
	
endmodule