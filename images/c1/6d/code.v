module clken_buf (clk, rclk, enb_l, tmb_l);
output clk;
input  rclk, enb_l, tmb_l;
reg    clken;
  always @ (rclk or enb_l or tmb_l)
    if (!rclk)  
      clken = !enb_l | !tmb_l;
  assign clk = clken & rclk;
endmodule