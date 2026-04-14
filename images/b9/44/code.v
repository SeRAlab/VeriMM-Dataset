module top_module(input clk, input reset, input enable,
   output reg [3:0] count);always @(posedge clk)
     if (reset)
       count <= 0;
     else if (enable)
       count <= count + 1;

endmodule