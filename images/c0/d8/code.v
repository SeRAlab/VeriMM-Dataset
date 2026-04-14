module aeMB2_spsram (
   dat_o,
   adr_i, dat_i, wre_i, ena_i, rst_i, clk_i
   ) ;
   parameter AW = 8;
   parameter DW = 32;
   output [DW-1:0] dat_o;  
   input [AW-1:0]  adr_i;
   input [DW-1:0]  dat_i;
   input 	   wre_i,
		   ena_i,		   
		   rst_i,
		   clk_i;
   reg [DW-1:0]		dat_o;
   reg [DW:1] 	   rRAM [(1<<AW)-1:0];
   reg [AW:1] 	   rADR;
   always @(posedge clk_i)
     if (wre_i) rRAM[adr_i] <= #1 dat_i;
   always @(posedge clk_i)
     if (rst_i)
       dat_o <= {(1+(DW-1)){1'b0}};
     else if (ena_i) 
       dat_o <= #1 rRAM[adr_i];	
   integer i;
   initial begin
      for (i=0; i<(1<<AW); i=i+1) begin
	 rRAM[i] <= $random;	 
      end
   end
endmodule