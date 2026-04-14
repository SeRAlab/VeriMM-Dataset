module top_module(
    out,
    in_0,
    in_1,
    in_2,
    in_3,
    in_4,
    in_5,
    in_6,
    in_7
);output out;
    input  in_0;
    input  in_1;
    input  in_2;
    input  in_3;
    input  in_4;
    input  in_5;
    input  in_6;
    input  in_7;

    wire and_0_out;
    wire and_1_out;
    wire and_2_out;
    wire and_3_out;
    wire and_4_out;
    wire and_5_out;
    wire and_6_out;

    assign and_0_out = in_0 & in_1;
    assign and_1_out = in_2 & in_3;
    assign and_2_out = in_4 & in_5;
    assign and_3_out = in_6 & in_7;
    assign and_4_out = and_0_out & and_1_out;
    assign and_5_out = and_2_out & and_3_out;
    assign and_6_out = and_4_out & and_5_out;
    assign out = and_6_out;

endmodule