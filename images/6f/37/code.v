module top_module(
    input wire clk, reset,
    input wire en,
    input wire [7:0] q1_next, q2_next, q3_next,
    output reg [7:0] q1_reg, q2_reg, q3_reg
   );always @(posedge clk)
      q1_reg <= q1_next;

   
   
   
   
   always @(posedge clk, posedge reset)
      if (reset)
         q2_reg <= 8'b0;
      else
         q2_reg <= q2_next;

   
   
   
   
   always @(posedge clk, posedge reset)
      if (reset)
         q3_reg <= 8'b0;
      else if (en)
         q3_reg <= q3_next;

endmodule