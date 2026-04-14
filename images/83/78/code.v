module top_module(input d, clk, reset, output reg q);always@(posedge clk)
    if(reset == 1)
      q <= 0;
    else
      q <= d;
endmodule