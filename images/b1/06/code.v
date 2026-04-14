module top_module(input            clk,
              input            rst_n,
              input            in,
              output reg [5:0] q
              );always @(posedge clk, negedge rst_n) 
     if (!rst_n) 
       q = 0;
     else 
       q <= q << 1 | in;
   
endmodule