module top_module(
   
   y,
   
   b, c
   );input b, c;

   output reg y;

   always @(*) begin : myproc
      y = b ^ c;
   end

endmodule