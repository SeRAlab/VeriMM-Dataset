module top_module(clk, rst, A, B);input clk, rst;
   input [3:0] A;
   output [3:0] B;
   
   reg [3:0] A_reg;
   
   assign B = ~A_reg + 1;
   
   always @(posedge clk)
      begin
         if (rst)
            A_reg <= 4'b0;
         else
            A_reg <= A;
      end
   
endmodule