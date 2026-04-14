module bw_u1_zhoai211_0p3x (z, a, b, c1, c2);
    output z; 
    input  c1;  
    input  c2;
    input  b;
    input  a;
    assign z = ~(( c1 | c2 ) & ( a ) & (b));
endmodule