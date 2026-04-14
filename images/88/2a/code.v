module top_module(
   input [3:0] A,
   input [3:0] B,
   input ctrl,
   output reg [3:0] sum,
   output reg [3:0] difference
);always @ (*) begin
      if (ctrl == 0) begin
         difference = 4'bxxxx; // set difference to undefined
         sum = A + B; // always calculate sum regardless of ctrl
      end
      else begin
         sum = 4'bxxxx; // set sum to undefined
         difference = A - B; // always calculate difference
      end
   end

endmodule