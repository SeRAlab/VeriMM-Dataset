module top_module(pm0, pm1, pm2, pm3, d0, d1);output  	d0, d1;
   
   
   input [3:0] 	pm0, pm1, pm2, pm3;
   
   
   reg   	d0, d1;
   reg [1:0]	int0, int1;
   reg [3:0]	pm_int0, pm_int1;

   always @ (pm0 or pm1 or pm2 or pm3)
	 begin
		int0 = (pm0<=pm1)?2'd0:2'd1; 
		int1 = (pm2<=pm3)?2'd2:2'd3; 
		pm_int0 = (pm0<=pm1)?pm0:pm1; 
		pm_int1 = (pm2<=pm3)?pm2:pm3; 
		{d1,d0} = (pm_int0<=pm_int1)?int0:int1; 
	 end 


endmodule