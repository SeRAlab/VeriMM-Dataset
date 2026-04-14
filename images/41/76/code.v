module top_module(
    input [3:0] data_in,
    input [1:0] sel,
    output reg data_out
);wire sel_0_bar;
    wire sel_1_bar;

    assign sel_0_bar = ~sel[0];
    assign sel_1_bar = ~sel[1];

    wire and_1;
    wire and_2;
    wire and_3;
    wire and_4;
    wire or_1;
    wire or_2;

    assign and_1 = data_in[0] & sel_0_bar & sel_1_bar;
    assign and_2 = data_in[1] & sel_0_bar & sel[1];
    assign and_3 = data_in[2] & sel[0] & sel_1_bar;
    assign and_4 = data_in[3] & sel[0] & sel[1];

    assign or_1 = and_1 | and_2;
    assign or_2 = and_3 | and_4;

    assign data_out = or_1 | or_2;

endmodule