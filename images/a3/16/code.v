module top_module(A,B,AndOut);input  A;
  input  B;
 output reg AndOut;
 
 always@(*) begin
  AndOut = A & B;
 end

endmodule