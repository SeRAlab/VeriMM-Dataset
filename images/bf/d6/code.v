module bw_u1_zhoai21_1x (z,b1,b2,a );
    output z;
    input  b1;
    input  b2;  
    input  a;
    assign z = ~(( b1 | b2 ) & ( a ));
endmodule