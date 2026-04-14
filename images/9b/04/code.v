module top_module(
    din_0,
    din_1,
    din_2,
    en,
    dout
);input din_0;
    input din_1;
    input din_2;
    input en;
    output dout;

    wire [2:0] inputs;
    assign inputs = {din_2, din_1, din_0};

    assign dout = (en == 1'b1) ? inputs[ $onehot0(inputs) ] : 1'bz;

endmodule