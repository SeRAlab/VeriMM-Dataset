module top_module(
    Y ,
    A0,
    A1,
    A2,
    A3,
    S0,
    S1
);output Y ;
    input  A0;
    input  A1;
    input  A2;
    input  A3;
    input  S0;
    input  S1;

    wire not_S0;
    wire not_S1;
    wire not_A0;
    wire not_A1;
    wire not_A2;
    wire not_A3;

    assign not_S0 = ~S0;
    assign not_S1 = ~S1;
    assign not_A0 = ~A0;
    assign not_A1 = ~A1;
    assign not_A2 = ~A2;
    assign not_A3 = ~A3;

    wire sel_00;
    wire sel_01;
    wire sel_10;
    wire sel_11;

    assign sel_00 = not_S0 & not_S1;
    assign sel_01 = S0 & not_S1;
    assign sel_10 = not_S0 & S1;
    assign sel_11 = S0 & S1;

    wire mux_out_00;
    wire mux_out_01;
    wire mux_out_10;
    wire mux_out_11;

    assign mux_out_00 = not_A0 & not_A1 & not_A2 & not_A3;
    assign mux_out_01 = not_A0 & not_A1 & not_A2 & A3;
    assign mux_out_10 = not_A0 & not_A1 & A2 & not_A3;
    assign mux_out_11 = not_A0 & not_A1 & A2 & A3;

    assign Y = (sel_00 & mux_out_00) | (sel_01 & mux_out_01) | (sel_10 & mux_out_10) | (sel_11 & mux_out_11);

endmodule