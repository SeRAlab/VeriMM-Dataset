module top_module(clk, sen, ena, gatedclk);input	clk;
   input	sen;
   input	ena;
   output	gatedclk;

   reg		ena_b;
   wire gatedclk = clk & ena_b;

   
   
   always @(clk or ena or sen) begin
      if (~clk) begin
        ena_b <= ena | sen;
      end
      else begin
	 if ((clk^sen)===1'bX) ena_b <= 1'bX;
      end
   end
   
   

endmodule