module up_down_counter (clk, rst_n, mode, count);
   input clk, rst_n, mode;
   output reg [3:0] count;

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         count <= 4'b0000;
      else if (mode)
         count <= count + 1;
      else
         count <= count - 1;
   end
endmodule