module top_module(
    out,
    in0,
    in1,
    in2,
    in3,
    sel0,
    sel1
);// Module ports
    output out;
    input  in0;
    input  in1;
    input  in2;
    input  in3;
    input  sel0;
    input  sel1;

    // Local signals
    wire mux_2to1_n0_out_Y;
    wire mux_2to1_n1_out_Y;
    wire mux_2to1_n2_out_Y;

    // 2-to-1 multiplexer using simple behavioral description
    assign mux_2to1_n0_out_Y = (sel1) ? in1 : in0;
    assign mux_2to1_n1_out_Y = (sel1) ? in3 : in2;
    assign mux_2to1_n2_out_Y = (sel0) ? mux_2to1_n1_out_Y : mux_2to1_n0_out_Y;

    // Buffer
    assign out = mux_2to1_n2_out_Y;

endmodule