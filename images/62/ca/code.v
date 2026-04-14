module top_module(
   
   out, mask,
   
   clk, in
   );input clk;
   input [2:0] in;
   output reg [3:0] out;
   output reg [3:0] mask;
   localparam [15:5] p = 11'h1ac;

   always @(posedge clk) begin
      
      out <= p[15 + in -: 5];
      
      mask[3] <= ((15 + in - 5) < 12);
      mask[2] <= ((15 + in - 5) < 13);
      mask[1] <= ((15 + in - 5) < 14);
      mask[0] <= ((15 + in - 5) < 15);
   end

endmodule