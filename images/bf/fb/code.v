module bw_u1_muxi21_2x (z, d0, d1, s);
output z;
input  d0, d1, s;
    assign z = s ? ~d1 : ~d0;
endmodule