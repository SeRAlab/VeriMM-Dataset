module top_module(

  

  clk,
  rst,

  

  tdd_rx_vco_en,
  tdd_tx_vco_en,
  tdd_rx_rf_en,
  tdd_tx_rf_en,

  

  ad9361_txnrx,
  ad9361_enable,

  

  ad9361_tdd_status
);parameter       MODE_OF_ENABLE = 0;

  localparam      PULSE_MODE = 0;
  localparam      LEVEL_MODE = 1;

  

  input           clk;
  input           rst;

  

  input           tdd_rx_vco_en;
  input           tdd_tx_vco_en;
  input           tdd_rx_rf_en;
  input           tdd_tx_rf_en;

  

  output          ad9361_txnrx;
  output          ad9361_enable;

  

  output  [ 7:0]  ad9361_tdd_status;


  

  reg             tdd_rx_rf_en_d = 1'b0;
  reg             tdd_tx_rf_en_d = 1'b0;

  reg             tdd_vco_overlap = 1'b0;
  reg             tdd_rf_overlap = 1'b0;

  wire            ad9361_txnrx_s;
  wire            ad9361_enable_s;

  
  assign ad9361_txnrx_s = tdd_tx_vco_en & ~tdd_rx_vco_en;

  always @(posedge clk) begin
    tdd_rx_rf_en_d <= tdd_rx_rf_en;
    tdd_tx_rf_en_d <= tdd_tx_rf_en;
  end

  assign ad9361_enable_s = (MODE_OF_ENABLE == PULSE_MODE) ?
                          ((~tdd_rx_rf_en_d & tdd_rx_rf_en) | (tdd_rx_rf_en_d & ~tdd_rx_rf_en) |
                           (~tdd_tx_rf_en_d & tdd_tx_rf_en) | (tdd_tx_rf_en_d & ~tdd_tx_rf_en)) :
                           (tdd_rx_rf_en | tdd_tx_rf_en);

  always @(posedge clk) begin
    if(rst == 1'b1) begin
      tdd_vco_overlap <= 1'b0;
      tdd_rf_overlap <= 1'b0;
    end else begin
      tdd_vco_overlap <= tdd_rx_vco_en & tdd_tx_vco_en;
      tdd_rf_overlap <= tdd_rx_rf_en & tdd_tx_rf_en;
    end
  end

  assign ad9361_tdd_status = {6'b0, tdd_rf_overlap, tdd_vco_overlap};

  assign ad9361_txnrx = ad9361_txnrx_s;
  assign ad9361_enable = ad9361_enable_s;

endmodule