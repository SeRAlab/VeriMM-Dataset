module top_module(
    input a, b, cin,
    output cout, sum );wire w1, w2, w3;

    // First stage of full adder
    xor x1(sum, a, b);
    xor x2(cout, sum, cin);

    // Generate intermediate signals for carry output
    assign w1 = a & b;        // w1 = a AND b
    assign w2 = sum & cin;    // w2 = sum AND cin
    assign w3 = a & cin;      // w3 = a AND cin

    // Calculate carry output
    assign cout = w1 | w2;    // cout = w1 OR w2

endmodule