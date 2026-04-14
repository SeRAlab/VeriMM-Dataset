module top_module(Q, Qbar, C, D, PREbar, CLRbar, Wen);input D, C, PREbar, CLRbar, Wen;
	output Q, Qbar;
	wire clock;
	wire databar, clockbar;
	wire master_nand1, master_nand2;
	wire nand1, nand2;
	wire master_q, master_qbar;
	and #1  (clock, Wen, C);
	not #1	(databar, D);
	not #1	(clockbar, clock);
	
	nand #1 m1(master_nand1,clock, D);
	nand #1 m2(master_nand2,clock, databar);
	nand #1 m3(master_qbar,master_nand2,master_q, CLRbar); 
	nand #1 m4(master_q,master_nand1,master_qbar, PREbar);
	
	nand #1 s1(nand1,clockbar, master_q);
	nand #1 s2(nand2,clockbar, master_qbar);
	nand #1 s3(Qbar,nand2,Q, CLRbar);
	nand #1 s4(Q,nand1,Qbar, PREbar);
	
	
	
	endmodule