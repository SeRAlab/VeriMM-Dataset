module comparator_1bit(A, B, Eq);
    input A, B;
    output Eq;
    
    assign Eq = (A == B);
endmodule