module half_adder (
    input a,
    input b,
    output sum,
    output carry
);

    // Half adder logic
    assign sum = a ^ b;
    assign carry = a & b;

endmodule