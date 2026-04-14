module top_module(
   input  clk,
   input  en_d2,
   input  D,
   output reg Q
   );always @ (posedge clk) begin
   	Q <= D;
   end
endmodule