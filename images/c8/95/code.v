module five_to_one (
    input A1,
    input A2,
    input B1,
    input C1,
    input D1,
    output Y
);

    wire temp1;
    wire temp2;

    assign temp1 = (A1 & A2);
    assign temp2 = (B1 & C1);

    assign Y = (temp1 & temp2);

endmodule