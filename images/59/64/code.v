module xor_module (
    input p, 
    input q, 
    output r);assign r = ~(p & q) | (~p & q) | (p & ~q);

endmodule