module bw_mckbuf_1p5x (clk, rclk, en);
output clk;
input  rclk;
input  en;
    assign clk = rclk & en ;
endmodule