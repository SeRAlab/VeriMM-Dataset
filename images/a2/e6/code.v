module top_module(A, B, Result);input [31:0] A, B;
   output reg [31:0] Result;


   always @(*) begin
      Result <= A + B;
   end
endmodule