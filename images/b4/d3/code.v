module top_module(input clk,output reg [15:0] pseudorand);always @(posedge clk) 
  pseudorand <= { pseudorand[14:0], pseudorand[7] ^ pseudorand[3] }; 
  initial pseudorand = 0; 
 endmodule