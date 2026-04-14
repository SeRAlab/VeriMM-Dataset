module logic_gate(
    input A1,
    input A2,
    input [1:0] B1,
    input [1:0] B2,
    input C1,
    output Y
);

    assign Y = (A1) ? 1'b1 : ((A2) ? 1'b0 : ((B1 > B2) ? 1'b1 : ((B1 < B2) ? 1'b0 : ((C1) ? 1'b1 : 1'b0))));

endmodule