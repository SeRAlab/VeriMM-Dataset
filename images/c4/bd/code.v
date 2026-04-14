module five_to_one (
    input A1,
    input A2,
    input A3,
    input A4,
    input B1,
    output Y
);

    wire b_and = A1 & A2 & A3 & A4; // logical AND of all inputs
    wire b_or = A1 | A2 | A3 | A4; // logical OR of all inputs

    assign Y = B1 ? b_and : b_or; // if B1 is high, output b_and. Otherwise, output b_or.

endmodule