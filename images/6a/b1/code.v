module top_module(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C1
);wire and0_out  ;
    wire and1_out  ;
    wire nor0_out_Y;

    assign and0_out = B1 & B2;
    assign and1_out = A1 & A2;
    assign nor0_out_Y = ~(and0_out | and1_out | C1);
    assign Y = nor0_out_Y;

endmodule