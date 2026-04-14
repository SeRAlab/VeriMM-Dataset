module three_input_module (
    input A1,
    input A2,
    input B1,
    output X
);

    assign X = (!A1 & A2) | (A1 & !A2) | (!B1 & (A1 | A2)) | (A1 & A2);

endmodule