module top_module(scndry_out,
    s_axi_aresetn,
    phy_tx_clk);output scndry_out;
  input s_axi_aresetn;
  input phy_tx_clk;

  wire phy_tx_clk;
  wire s_axi_aresetn;
  wire s_level_out_d1_cdc_to;
  wire scndry_out;

  reg s_level_out_d1_cdc_to_reg;
  reg scndry_out_reg;

  always @(posedge phy_tx_clk) begin
    scndry_out_reg <= s_level_out_d1_cdc_to_reg;
  end

  always @(posedge phy_tx_clk) begin
    s_level_out_d1_cdc_to_reg <= s_axi_aresetn;
  end

endmodule