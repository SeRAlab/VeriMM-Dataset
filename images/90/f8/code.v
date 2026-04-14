module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    output X
);wire temp1, temp2;

    assign temp1 = (A1) ? A2 : 1'b0;
    assign temp2 = (A1) ? 1'b0 : ((A3) ? B1 : (A2 & B1));

    assign X = temp1 | temp2;

endmodule