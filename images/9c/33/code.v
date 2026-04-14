module full_adder(a, b, cin, sum, cout);

    input  a;
    input  b;
    input  cin;
    output sum;
    output cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule