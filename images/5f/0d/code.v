module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    input B1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
);wire and_output;
    assign and_output = A1 & A2 & A3 & A4;

    assign Y = (B1 == 0) ? and_output : ~and_output;

endmodule