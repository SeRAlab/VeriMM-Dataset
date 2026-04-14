module top_module(
    input a, b, cin,
    output cout, sum
);wire w1, w2, w3;
    
    // XOR gate for sum calculation
    xor(sum, a, b, cin);
    
    // AND gate for carry-out calculation
    and(w1, a, b);
    and(w2, a, cin);
    and(w3, b, cin);
    or(cout, w1, w2, w3);
    
endmodule