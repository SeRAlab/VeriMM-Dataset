module top_module(clk, rst, en, init, out);input clk,rst;
  input en, init;
  output reg out;
  always@(posedge clk, posedge rst)begin
    if (rst) out <= 0;
    else if (init) out <= 0;
    else if (en) out <= 1;
    else out <= out;
  end
endmodule