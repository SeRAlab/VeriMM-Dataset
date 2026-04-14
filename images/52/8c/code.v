module top_module(/*AUTOARG*/
   // Inputs
   clk,
   // Outputs
   result
   );input clk;
   output reg [63:0] result;
   
   reg [63:0] crc = 64'h0;
   wire [7:0] poly = 8'b10011011;
   
   always @(posedge clk) begin
      crc <= crc << 1;
      if (crc[63] == 1) begin
         crc <= crc ^ {64'h0, poly};
      end
      result <= result + crc;
   end
   
endmodule