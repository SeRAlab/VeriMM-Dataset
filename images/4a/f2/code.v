module top_module(
    input clock,
    input [2:0] counter_param,
    input [3:0] counter_type,
    input [8:0] data_in,
    input pll_areset_in,
    input pll_scandataout,
    input pll_scandone,
    input read_param,
    input reconfig,
    input reset,
    input write_param,
    output busy,
    output [8:0] data_out,
    output pll_areset,
    output pll_configupdate,
    output pll_scanclk,
    output pll_scanclkena,
    output pll_scandata
);assign pll_areset = pll_areset_in | reset;
    assign pll_configupdate = reconfig;
    assign pll_scanclk = pll_scandataout & !pll_scandone;
    assign pll_scanclkena = pll_scandataout & pll_scandone;
    assign pll_scandata = pll_scandataout & pll_scandone;
    assign busy = read_param | write_param;

    assign data_out = (read_param) ? data_in :
                      (write_param) ? {counter_param, 4'b0000} :
                      {counter_param, counter_type, data_in};

endmodule