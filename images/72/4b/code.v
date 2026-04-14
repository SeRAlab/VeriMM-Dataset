module top_module(
    input rst_all,
    input rst_dev,

    output rst_mac,
    output rst_adc,
    output rst_fifod,
    output rst_fifoc,
    output rst_eth2mac,
    output rst_mac2fifoc,
    output rst_fifoc2cs,
    output rst_adc2fifod,
    output rst_fifod2mac
);assign rst_mac = rst_all;
    assign rst_adc = rst_dev;
    assign rst_fifod = rst_dev;
    assign rst_fifoc = rst_all;
    assign rst_eth2mac = rst_all;
    assign rst_mac2fifoc = rst_all;
    assign rst_fifoc2cs = rst_all;
    assign rst_adc2fifod = rst_dev;
    assign rst_fifod2mac = rst_dev;

endmodule