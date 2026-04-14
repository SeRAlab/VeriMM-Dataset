module four_to_one (
    input A,
    input B,
    input C,
    input D,
    output Y
);

    assign Y = A | B | C | D;

endmodule