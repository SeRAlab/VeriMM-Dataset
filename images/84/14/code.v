module top_module(
    input a, 
    input b,
    output wire out
);wire w1, w2, w3;
    
    xor gate1(w1, a, b);
    xor gate2(w2, a, w1);
    xor gate3(w3, b, w1);
    xor gate4(out, w2, w3);
    
endmodule