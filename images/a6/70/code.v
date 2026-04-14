module top_module(
    cal_blk_clk,
    fixedclk,
    fixedclk_fast,
    gxb_powerdown,
    pll_inclk,
    reconfig_clk,
    reconfig_togxb,
    rx_analogreset,
    rx_cruclk,
    rx_datain,
    rx_digitalreset,
    rx_seriallpbken,
    tx_ctrlenable,
    tx_datain,
    tx_digitalreset,
    reconfig_fromgxb,
    rx_clkout,
    rx_ctrldetect,
    rx_dataout,
    rx_disperr,
    rx_errdetect,
    rx_patterndetect,
    rx_rlv,
    rx_rmfifodatadeleted,
    rx_rmfifodatainserted,
    rx_runningdisp,
    rx_syncstatus,
    tx_clkout,
    tx_dataout
);input cal_blk_clk;
    input fixedclk;
    input [5:0] fixedclk_fast;
    input [0:0] gxb_powerdown;
    input pll_inclk;
    input reconfig_clk;
    input [3:0] reconfig_togxb;
    input [0:0] rx_analogreset;
    input [0:0] rx_cruclk;
    input [0:0] rx_datain;
    input [0:0] rx_digitalreset;
    input [0:0] rx_seriallpbken;
    input [0:0] tx_ctrlenable;
    input [7:0] tx_datain;
    input [0:0] tx_digitalreset;

    output [16:0] reconfig_fromgxb;
    output rx_clkout;
    output [0:0] rx_ctrldetect;
    output [7:0] rx_dataout;
    output [0:0] rx_disperr;
    output [0:0] rx_errdetect;
    output [0:0] rx_patterndetect;
    output [0:0] rx_rlv;
    output [0:0] rx_rmfifodatadeleted;
    output [0:0] rx_rmfifodatainserted;
    output [0:0] rx_runningdisp;
    output [0:0] rx_syncstatus;
    output [0:0] tx_clkout;
    output [0:0] tx_dataout;

    wire [16:0] reconfig_fromgxb;
    wire rx_clkout;
    wire [0:0] rx_ctrldetect;
    wire [7:0] rx_dataout;
    wire [0:0] rx_disperr;
    wire [0:0] rx_errdetect;
    wire [0:0] rx_patterndetect;
    wire [0:0] rx_rlv;
    wire [0:0] rx_rmfifodatadeleted;
    wire [0:0] rx_rmfifodatainserted;
    wire [0:0] rx_runningdisp;
    wire [0:0] rx_syncstatus;
    wire [0:0] tx_clkout;
    wire [0:0] tx_dataout;

    // Your code here

endmodule