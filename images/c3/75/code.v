module counter (/*AUTOARG*/
   // Inputs
   clk,
   // Outputs
   count
   );
   input clk;
   output reg [3:0] count;

   always @ (posedge clk) begin
      if (count == 10) begin
         count <= 0;
      end
      else begin
         count <= count + 1;
      end
   end

endmodule