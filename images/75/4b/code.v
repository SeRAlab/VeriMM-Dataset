module top_module(/*AUTOARG*/
   // Inputs
   clk,
   reset,

   // Outputs
   count,
   done
   );input clk, reset;
   output reg [3:0] count;
   output reg done;

   always @ (posedge clk) begin
      if (reset) begin
         count <= 0;
         done <= 1;
      end
      else begin
         if (count == 15) begin
            count <= 0;
            done <= 1;
         end
         else begin
            count <= count + 1;
            done <= 0;
         end
      end
   end

endmodule