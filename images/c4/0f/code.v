module dram_pad_scan_jtag (
    input rcv_in,
    input drv_oe,
    output oe
);
    assign oe = rcv_in & drv_oe;
endmodule