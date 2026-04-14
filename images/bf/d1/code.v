module fasm_tparam (
   dat_o, xdat_o,
   dat_i, adr_i, wre_i, stb_i, rst_i, clk_i, xdat_i, xadr_i, xwre_i,
   xstb_i, xrst_i, xclk_i
   ) ;
   parameter AW = 4;
   parameter DW = 6;
   output [DW-1:0] dat_o; 
   input [DW-1:0]  dat_i; 
   input [AW-1:0]  adr_i; 
   input 	   wre_i; 
   input 	   stb_i; 
   input 	   rst_i,
		   clk_i;
   output [DW-1:0] xdat_o; 
   input [DW-1:0]  xdat_i; 
   input [AW-1:0]  xadr_i; 
   input 	   xwre_i; 
   input 	   xstb_i; 
   input 	   xrst_i,
		   xclk_i;
   reg [DW-1:0]    lram [(1<<AW)-1:0];
   always @(posedge xclk_i)
     if (xwre_i) lram[xadr_i] <= #1 xdat_i;	
   assign 	   xdat_o = {(DW){1'bX}};
   assign 	   dat_o = lram[adr_i];   
   integer i;
   initial begin
      for (i=0; i<(1<<AW); i=i+1) begin
	 lram[i] <= $random;	 
      end
   end
endmodule