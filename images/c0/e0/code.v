module fasm_sparam (
   dat_o,
   dat_i, adr_i, wre_i, stb_i, clk_i, rst_i
   ) ;
   parameter AW = 5; 
   parameter DW = 2; 
   output [DW-1:0] dat_o;  
   input [DW-1:0]  dat_i;
   input [AW-1:0]  adr_i;
   input 	   wre_i;
   input 	   stb_i; 
   input 	   clk_i,
		   rst_i;
   reg [DW-1:0]    lram [(1<<AW)-1:0];
   always @(posedge clk_i)
     if (wre_i) 
	  lram[adr_i] <= #1 dat_i;	
   assign 	   dat_o = lram[adr_i];
   integer i;
   initial begin
      for (i=0; i<(1<<AW); i=i+1) begin
	 lram[i] <= $random;	 
      end
   end
endmodule