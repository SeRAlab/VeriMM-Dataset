module top_module(in, outh, outl);input [6:0]in;
    output [3:0]outh;
    output [3:0]outl;

    assign outh = in / 10;
    assign outl = in % 10;
endmodule