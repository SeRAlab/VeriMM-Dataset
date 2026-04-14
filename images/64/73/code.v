module top_module(a, da, db, dc, dd, de, df, dg, dh, q);input  [2:0]  a;	
input  [7:0]  da, db, dc, dd, de, df, dg, dh;
output  [7:0] q;
		
assign  q = (a==0) ? da:  (a==1) ? db:
			(a==2) ? dc:  (a==3) ? dd:
			(a==4) ? de:  (a==5) ? df:
			(a==6) ? dg: dh;

endmodule