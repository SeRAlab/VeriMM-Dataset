module bw_mckbuf_11x (clk, rclk, en);
output clk;
input  rclk;
input  en;
    assign clk = rclk & en ;
endmodule