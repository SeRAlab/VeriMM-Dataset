module top_module(/*AUTOARG*/
   // Outputs
   q,
   // Inputs
   clk, rst_l, d
   );input clk;
   input rst_l;
   input [3:0] d;
   output reg [3:0] q;

   always @(posedge clk, negedge rst_l) begin
      if (~rst_l) begin
         q <= 4'b0000;
      end else begin
         q <= d;
      end
   end

endmodule