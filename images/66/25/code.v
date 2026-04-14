module top_module(a, b, c, cin, sum, cout);input a, b, c, cin;
    output sum, cout;
    
    wire w1, w2, w3;
    
    assign w1 = a ^ b;
    assign w2 = c ^ cin;
    assign sum = w1 ^ w2;
    assign w3 = w1 & w2;
    assign cout = w3 | (a & b) | (c & cin);
endmodule