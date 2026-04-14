module top_module(
   // Outputs
   out2_r,
   // Inputs
   pla_ph1, pla_ph2, dsp_reset, padd
   );input pla_ph1, pla_ph2, dsp_reset;
   input [7:0] padd;
   output [7:0] out2_r;

   wire 	pla_ph1, pla_ph2, dsp_reset;
   wire [7:0] 	padd;
   reg [7:0] 	out2_r;

   reg [7:0] 	latched_r;

   always @(posedge pla_ph1 or posedge dsp_reset) begin
      if (dsp_reset)
         latched_r <= 8'h00;
      else
         latched_r <= padd;
   end

   always @(posedge pla_ph2 or posedge dsp_reset) begin
      if (dsp_reset)
         out2_r <= 8'h00;
      else
         out2_r <= latched_r;
   end

endmodule