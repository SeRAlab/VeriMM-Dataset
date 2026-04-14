module remove_msb(
   input [3:0] A,
   output reg [2:0] B
   );
   
   always @(*) begin
      B = A << 1;
      B = B[2:0];
   end
   
endmodule