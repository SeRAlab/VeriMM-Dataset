module top_module(
    input data0,
    input data1,
    input data2,
    input data3,
    input sel0,
    input sel1,
    output mux_out
);wire sel0_not, sel1_not;
    wire temp0, temp1, temp2;
    wire mux_out0, mux_out1;

    // Not gates for selection inputs
    assign sel0_not = ~sel0;
    assign sel1_not = ~sel1;

    // Intermediate logic for the MUX
    assign mux_out0 = (sel1_not & sel0_not & data0) | (sel1_not & sel0 & data1);
    assign mux_out1 = (sel1 & sel0_not & data2) | (sel1 & sel0 & data3);

    // Final output logic
    assign mux_out = mux_out0 | mux_out1;

endmodule