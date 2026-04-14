module top_module(
        input clk,
        input [13:0] dac_dataA,
        input [13:0] dac_dataB,
        output [13:0] dac_dataA_out,
        output [13:0] dac_dataB_out,
        output dac_clkA_out,
        output dac_clkB_out,
        output dac_gset_out,
        output dac_mode_out,
        output dac_sleep_out
    );assign dac_dataA_out=dac_dataA;
    assign dac_dataB_out=dac_dataB;
    assign dac_clkA_out=~clk;
    assign dac_clkB_out=~clk;
    assign dac_gset_out=1'b1;
    assign dac_mode_out=1'b1;
    assign dac_sleep_out=1'b0;
    
endmodule