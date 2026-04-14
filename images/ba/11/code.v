module top_module(v0, v1, v2, v3, v4, v5, l0, l1, l2, l3, l4, l5, l6, out);input l0, l1, l2, l3, l4, l5, l6;
    input [7:0] v0, v1, v2, v3, v4, v5;
    output [7:0] out;
    genvar i;
    generate
        for(i=0;i<=7;i=i+1)
          begin : label
            assign out[i] = (v0[i]&l0)|(v1[i]&l1)|(v2[i]&l2)|(v3[i]&l3)|(v4[i]&l4)|(v5[i]&l5)|(v0[7]&l6);
          end 
    endgenerate
endmodule