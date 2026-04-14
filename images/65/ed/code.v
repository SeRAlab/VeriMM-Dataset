module top_module(
  q,
  clk, d, rst_n
);output q;
  reg    q_nodelay;
  input  clk,
         d,
         rst_n;

  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        q_nodelay <= 0;
      else
        q_nodelay <= d;
    end

  assign #2 q = q_nodelay;

endmodule