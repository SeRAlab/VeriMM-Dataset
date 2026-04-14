module top_module(input wire clk, input wire write);always @(posedge clk)  begin
     assert(write == 1'b0);
  end
endmodule