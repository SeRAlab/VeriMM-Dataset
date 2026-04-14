module register_4bit (clk, rst, en, d, q);
   input clk, rst, en;
   input [3:0] d;
   output [3:0] q;
   reg [3:0] q;

   always @(posedge clk or posedge rst) begin
      if (rst)
         q <= 4'b0000;
      else if (en)
         q <= d;
   end
endmodule