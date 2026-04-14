module aeMB2_sparam (
   dat_o,
   adr_i, dat_i, wre_i, clk_i, ena_i
   ) ;
   parameter AW = 5; 
   parameter DW = 2; 
   output [DW-1:0] dat_o;  
   input [AW-1:0]  adr_i;
   input [DW-1:0]  dat_i;
   input 	   wre_i;
   input 	   clk_i, ena_i;
   reg [DW-1:0]    rRAM [(1<<AW)-1:0];
   reg [AW-1:0]    rADDR;
   always @(posedge clk_i)
     begin
	if (wre_i) 
	  rRAM[adr_i] <= #1 dat_i;	
     end
   assign 	   dat_o = rRAM[adr_i];
   integer i;
   initial begin
      for (i=0; i<(1<<AW); i=i+1) begin
	 rRAM[i] <= {(DW){1'b0}};	 
end
   end
endmodule