module aeMB2_dparam (
   dat_o, xdat_o,
   adr_i, dat_i, wre_i, xadr_i, xdat_i, xwre_i, clk_i, ena_i
   ) ;
   parameter AW = 5; 
   parameter DW = 2; 
   output [DW-1:0] dat_o;  
   input [AW-1:0]  adr_i;
   input [DW-1:0]  dat_i;
   input 	   wre_i;
   output [DW-1:0] xdat_o;  
   input [AW-1:0]  xadr_i;
   input [DW-1:0]  xdat_i;
   input 	   xwre_i;
   input 	   clk_i, 
		   ena_i;
   reg [DW-1:0]    rRAM [(1<<AW)-1:0];
   always @(posedge clk_i)
     if (wre_i) rRAM[adr_i] <= #1 dat_i;	
   assign 	   dat_o = rRAM[adr_i];
   assign 	   xdat_o = rRAM[xadr_i];   
   integer 	   i;
   initial begin
      for (i=0; i<(1<<AW); i=i+1) 
	begin
	   rRAM[i] <= {(DW){1'b0}};
end
   end
endmodule