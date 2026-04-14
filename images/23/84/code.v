module dac_24bit (
    input [23:0] din,
    output [7:0] dout
);
    assign dout = (din * 255) / 16777215;
endmodule