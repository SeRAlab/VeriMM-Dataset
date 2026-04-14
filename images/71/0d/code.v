module top_module(
    input wire clk,
    input wire rx_datain,
    output reg tx_dataout
);// Uncomment the following line when the module is available or define it correctly.
    // altpcie_serdes_4sgx_x1d_gen2_08p serdes (
    //     .cal_blk_clk(clk),
    //     .rx_datain(rx_datain),
    //     .tx_dataout(tx_dataout)
    // );

    always @(posedge clk) begin
        tx_dataout <= ~rx_datain;
    end

endmodule