module top_module(
    out,
    in0,
    in1,
    in2,
    in3,
    sel0,
    sel1
);output out;
    input in0;
    input in1;
    input in2;
    input in3;
    input sel0;
    input sel1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire sel0_not;
    wire sel1_not;
    wire in0_sel;
    wire in1_sel;
    wire in2_sel;
    wire in3_sel;

    assign sel0_not = ~sel0;
    assign sel1_not = ~sel1;

    assign in0_sel = in0 & sel0_not & sel1_not;
    assign in1_sel = in1 & sel0_not & sel1;
    assign in2_sel = in2 & sel0 & sel1_not;
    assign in3_sel = in3 & sel0 & sel1;

    assign out = in0_sel | in1_sel | in2_sel | in3_sel;

endmodule