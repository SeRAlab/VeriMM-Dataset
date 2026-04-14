module fasm_spsram_wbr (
   dat_o,
   dat_i, adr_i, wre_i, stb_i, rst_i, clk_i
   );
   parameter AW = 8;  
   parameter DW = 32; 
   output [DW-1:0] dat_o; 
   input [DW-1:0]  dat_i; 
   input [AW-1:0]  adr_i; 
   input 	   wre_i; 
   input 	   stb_i; 
   input 	   rst_i,
		   clk_i;
   reg [AW-1:0]    rA;   
   reg [DW-1:0]    bram [(1<<AW)-1:0]; 
   always @(posedge clk_i)
     if (stb_i)
       begin
	  rA <= #1 adr_i;	  
	  if (wre_i) 
	    bram[adr_i] <= #1 dat_i;	  
       end
   assign 	   dat_o = bram[rA]; 
   integer i;
   initial begin
      for (i=0; i<(1<<AW); i=i+1) begin
	 bram[i] <= $random;	 
      end
   end
endmodule