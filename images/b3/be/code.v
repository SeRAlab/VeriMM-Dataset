module top_module(
  input ref_clk,
  input txp,
  output reg rxp
);reg clk_tmp;
  initial
     clk_tmp <= 1'b0;
  always
     #4 clk_tmp <= ~clk_tmp;
  
  reg reconfig_clk_tmp;
  initial
     reconfig_clk_tmp <= 1'b0;
  always
     #20 reconfig_clk_tmp <= ~reconfig_clk_tmp;
  
  reg [2:0] sync_cnt;
  always @(posedge ref_clk) begin
    if (sync_cnt == 3) begin
      sync_cnt <= 0;
      rxp <= txp;
    end
    else begin
      sync_cnt <= sync_cnt + 1;
    end
  end
  
  reg [4:0] reconfig_cnt;
  always @(posedge clk_tmp) begin
    if (reconfig_cnt == 19) begin
      reconfig_cnt <= 0;
    end
    else begin
      reconfig_cnt <= reconfig_cnt + 1;
    end
  end
  
  always @(posedge ref_clk) begin
    if (reconfig_cnt == 9) begin
      clk_tmp <= ~clk_tmp;
    end
  end

endmodule