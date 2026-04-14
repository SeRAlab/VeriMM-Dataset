module adc_24_to_10 (
    input [23:0] din,
    output [9:0] dout
);
    assign dout = din[23:14]; // Upper 10 bits of the 24-bit input
endmodule