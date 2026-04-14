module dff_async_reset (clk, rst, en, d, q);
   input clk, rst, en, d;
   output reg q;
   
   always @(posedge clk or posedge rst) begin
      if (rst)
         q <= 1'b0;
      else if (en)
         q <= d;
   end
endmodule