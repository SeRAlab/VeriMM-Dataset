module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin; // Calculate the sum
    assign cout = (a & b) | (b & cin) | (a & cin); // Calculate the carry-out

endmodule