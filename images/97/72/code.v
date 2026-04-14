module top_module(/*AUTOARG*/
   // Outputs
   out, mask,
   // Inputs
   clk, in
   );input clk;
   input [6:0] in;	// Note much wider than any index
   output reg [3:0] out;
   output reg [3:0] mask;
   localparam [15:5] p = 11'h1ac;

   always @(posedge clk) begin
      // Calculate the value of out
      out <= p[15 + in -: 5];

      // Calculate the value of mask
      mask[3] <= ((15 + in - 5) < 12);
      mask[2] <= ((15 + in - 5) < 13);
      mask[1] <= ((15 + in - 5) < 14);
      mask[0] <= ((15 + in - 5) < 15);
   end

endmodule