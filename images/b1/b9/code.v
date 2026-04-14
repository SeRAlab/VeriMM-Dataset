module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    input B1,
    output Y
);wire temp1, temp2, temp3;

    and(temp1, A1, A2);
    and(temp2, A3, A4);
    and(temp3, temp1, temp2);
    and(Y, temp3, B1);

endmodule