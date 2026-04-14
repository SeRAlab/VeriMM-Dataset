module top_module(clk,rst,in,q);input clk,rst;
  input in;
  output reg [3:0] q;
  always @(posedge clk)
      begin
        if (rst)
          q <= 0;
          else
          q <= {in,q[3:1]};
      end
endmodule