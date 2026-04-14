module nor3 (output o, input i0, i1, i2);
    wire w1, w2, w3, w4;
    
    not n1 (w1, i0);
    not n2 (w2, i1);
    not n3 (w3, i2);
    nor n4 (o, w1, w2, w3);
endmodule