module top_module(q,qbar,clock,data);output q, qbar;
	input clock, data;
	
	wire databar, clockbar;
	wire master_nand1, master_nand2;
	wire nand1, nand2;
	wire master_q, master_qbar;
	
	
	not #1	(databar, data);
	not #1		(clockbar, clock);
	
	nand #1 m1(master_nand1,clock, data);
	nand #1 m2(master_nand2,clock, databar);
	nand #1 m3(master_qbar,master_nand2,master_q);
	nand #1 m4(master_q,master_nand1,master_qbar);
	
	nand #1 s1(nand1,clockbar, master_q);
	nand #1 s2(nand2,clockbar, master_qbar);
	nand #1 s3(qbar,nand2,q);
	nand #1 s4(q,nand1,qbar);
	
endmodule