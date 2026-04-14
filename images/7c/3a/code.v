module top_module(/*AUTOARG*/
   // Inputs
   clk, rst, en,
   // Outputs
   count
   );// verilator coverage_off
   input clk, rst, en;
   output [3:0] count;
   // CHECK_COVER_MISSING(-1)

   reg [3:0] count_reg;

   always @(posedge clk or negedge rst) begin
      if (~rst) begin
         count_reg <= 4'b0;
      end else if (en) begin
         count_reg <= count_reg + 1;
      end
   end

   assign count = count_reg;

endmodule