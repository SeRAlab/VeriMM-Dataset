module top_module(/*AUTOARG*/
   // Inputs
   clk,
   data_in,

   // Outputs
   data_out,
   valid
   );input clk;
   input [3:0] data_in;
   output [2:0] data_out;
   output valid;

   reg [2:0] data_out_reg;
   reg valid_reg;

   always @(posedge clk) begin
      if (data_in >= 8) begin
         data_out_reg <= data_in[2:0];
         valid_reg <= 1;
      end else begin
         valid_reg <= 0;
      end
   end

   assign data_out = data_out_reg;
   assign valid = valid_reg;

endmodule