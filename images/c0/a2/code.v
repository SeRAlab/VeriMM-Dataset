module bw_u1_nand3_10x (
    z,
    a,  
    b,  
    c );
    output z;
    input  a;
    input  b;
    input  c;
    assign z = ~( a & b & c );
endmodule