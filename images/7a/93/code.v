module top_module(/*AUTOARG*/
   // Outputs
   count,
   // Inputs
   clk, reset, load, up_down,
   load_val
   );input clk, reset, load, up_down;
   input [2:0] load_val;
   
   output reg [2:0] count;
   
   always @(posedge clk) begin
      if (reset) begin
         count <= 3'b0;
      end
      else if (load) begin
         count <= load_val;
      end
      else begin
         if (up_down) begin
            count <= count + 1;
         end
         else begin
            count <= count - 1;
         end
      end
   end
   
endmodule