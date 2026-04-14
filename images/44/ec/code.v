module top_module(q, q_bar, d, clk, rst);output q, q_bar;
  input d, clk, rst;
  reg q;

  always @(posedge clk or posedge rst)
    if (rst)
      q <= 1'b0;
    else
      q <= d;

  not(q_bar, q);

endmodule