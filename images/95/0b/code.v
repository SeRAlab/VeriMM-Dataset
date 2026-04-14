module full_adder(
    input a,
    input b,
    input carry_in,
    output sum,
    output carry_out
);

assign sum = a ^ b ^ carry_in;
assign carry_out = (a & b) | (b & carry_in) | (a & carry_in);

endmodule