module top_module(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);wire ab = a & b;
    wire ac = a & cin;
    wire bc = b & cin;
    wire abc = ab & cin;

    assign sum = a ^ b ^ cin;
    assign cout = abc | ac | bc;

endmodule