module DAC (
    input [7:0] din,
    output [9:0] dout
);
    assign dout = din * 4;
endmodule