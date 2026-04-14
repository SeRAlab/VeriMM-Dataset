module register_16bit (clk, clr, d, q);
   input clk, clr;
   input [15:0] d;
   output reg [15:0] q;

   always @(posedge clk) begin
      if (clr)
         q <= 16'b0000000000000000;
      else
         q <= d;
   end
endmodule