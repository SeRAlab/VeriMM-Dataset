module binary_counter(clk, rst, count);

   input clk, rst;
   output reg [3:0] count;

   always @(posedge clk or posedge rst)
   begin
      if (rst) // reset counter to 0
         count <= 4'b0000;
      else // increment counter
         count <= count + 1;
   end

endmodule