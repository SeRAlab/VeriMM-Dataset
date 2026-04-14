module top_module(x0, x1, y0, y1, eqin, gtin, ltin, eqout, gtout, ltout);input x0, x1, y0, y1;				
	input eqin, gtin, ltin;				
	output eqout, gtout, ltout;		

	
	
	
	
	assign eqout = eqin & (x0 ~^ y0) & (x1 ~^ y1);
	
	
	
	
	
	

	
	
	
	
	
	
   
   
   
   
   
   
   
   
   
   
   
   
   
   
	assign gtout = (gtin | (x0 & ~y0) | (x1 & ~y0 & ~y1) | (x0 & x1 & y0 & ~y1)) & ~ltin;
	
	
	
	
	

	
	
	
	
	
	
	assign ltout = ltin | ~(eqout | gtout);
	
	
	

	
	

	
	
	
	
	
	
	

endmodule