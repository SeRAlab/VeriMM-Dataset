module top_module(
   
   outy_w92, outz_w22,
   
   clk, inw_w31, inx_w11
   );input 	clk;
   input [30:0]	inw_w31;
   input [10:0]	inx_w11;
   output reg [91:0] outy_w92  ;
   output reg [21:0] outz_w22  ;

   always @(posedge clk) begin
      outy_w92 <= {inw_w31[29:0],inw_w31[29:0],inw_w31[29:0],2'b00};
      outz_w22 <= {inx_w11[10:0],inx_w11[10:0]};
   end

endmodule