module logic_gate (
    input A1,
    input A2,
    input A3,
    input A4,
    input B1,
    output Y
);

    assign Y = (A1 & A2 & A3 & A4) | B1;

endmodule