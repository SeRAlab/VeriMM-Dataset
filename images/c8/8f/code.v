module my_module (
    input A1,
    input A2,
    input A3,
    input B1,
    input C1,
    output X
);

    assign X = (A1 | (A2 & !A1) | (A3 & !A2 & !A1)) ? 1'b1 : 1'b0;

endmodule