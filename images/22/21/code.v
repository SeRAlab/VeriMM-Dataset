module hazard_detection(
    input A,
    input B,
    input C,
    output Y
);
    wire AB, NOT_A, NOT_A_C;

    assign AB = A & B;
    assign NOT_A = ~A;
    assign NOT_A_C = NOT_A & C;

    assign Y = AB | NOT_A_C;

endmodule