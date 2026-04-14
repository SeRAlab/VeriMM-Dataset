module top_module(clk, reset, d, q, qn);input clk, reset, d;
   output reg q, qn; // Changed to output reg for sequential logic

   always @(posedge clk or negedge reset) begin
      if (reset == 0) begin
         q <= 0;
         qn <= 1;
      end else begin
         q <= d;
         qn <= ~d;
      end
   end
endmodule