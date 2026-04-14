module top_module(
   
   key,
   
   pdi, data_core, data_mode, wr, clk, en, crct
   ) ;output [127:0] key;
   
   input [31:0]   pdi;
   input [127:0]  data_core, data_mode;
   input 	  wr, clk, en, crct;

   reg [127:0]    bfr;

   assign key = bfr;
   
   always @ (posedge clk) begin
      if (wr) begin
         bfr <= {bfr[128-33:0], 
		 pdi};
      end
      else if (en) begin
         bfr <= data_core;	 
      end
      else if (crct) begin
	 bfr <= data_mode;	 
      end
   end
   
endmodule