module top_module(
   input [7:0] A,
   input [7:0] B,
   input CTRL,
   output reg [7:0] RESULT
);always @(*) begin
      if (CTRL == 0) begin
         RESULT = A + B;
      end else begin
         RESULT = A - B;
      end
   end
   
endmodule