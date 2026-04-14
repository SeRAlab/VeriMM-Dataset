module up_down_counter (clk, rst_n, up_down, count);
   input clk, rst_n, up_down;
   output reg [3:0] count;

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         count <= 4'b0000;
      else if (up_down)
         count <= count + 1;
      else
         count <= count - 1;
   end
endmodule