module bw_u1_nand4_0p6x (
    z,
    a,  
    b,  
    c,  
    d );
    output z;
    input  a;
    input  b;
    input  c;
    input  d;
    assign z = ~( a & b & c & d );
endmodule