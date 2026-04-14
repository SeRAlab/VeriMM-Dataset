module top_module(
   input clk,
   input toggle,
   input [31:0] cyc,
   output reg out
   );always @(posedge clk) begin
      if (toggle && cyc == 5) begin
         out <= 1;
         $display("*COVER: Cyc==5");
      end
      else begin
         out <= 0;
      end
   end

endmodule