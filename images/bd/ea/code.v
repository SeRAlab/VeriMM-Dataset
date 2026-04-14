module top_module(/*AUTOARG*/
   // Inputs
   clk,
   data_in,
   enable,
   // Outputs
   data_out
   );input clk;
   input [3:0] data_in;
   input enable;
   output reg [2:0] data_out;
   
   initial data_out = 0;
   
   always @(posedge clk) begin
      if (enable == 1'b1) begin
         data_out <= data_in + 3'b010; // 2 in binary is 010
      end else begin
         data_out <= data_in;
      end
   end
   
endmodule