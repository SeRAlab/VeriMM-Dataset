module half_adder (
    input A,
    input B,
    output sum,
    output carry_out
);

    assign sum = A ^ B;
    assign carry_out = A & B;

endmodule