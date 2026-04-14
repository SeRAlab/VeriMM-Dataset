module zckenbuf_prim (clk, rclk, en_l, tm_l);
output clk;
input  rclk, en_l, tm_l;
reg    clken;
  always @ (rclk or en_l or tm_l)
    if (!rclk)  
      clken <= ~en_l | ~tm_l;
  assign clk = clken & rclk;
endmodule