module top_module(
    input wire clk,
    input wire x0, y0, z0,
    output reg x3, y3, z3
   );reg x1, x2, y1, y2, z1, z2;
   
   always @(posedge clk)
   begin
      x1 <= x0;
      x2 <= x1;
      x3 <= x2;
   end

   
   always @(posedge clk)
   begin
      y1 = y0;
      y2 = y1;
      y3 = y2;
   end
   

   
   always @(posedge clk)
   begin
      z1 = z0;
      z3 = z2;
      z2 = z1;
   end
   
endmodule