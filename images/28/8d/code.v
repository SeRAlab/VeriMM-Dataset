module merge_sort(input [3:0] a, input [3:0] b, input [3:0] c, input [3:0] d,  
                  output [3:0] out1, output [3:0] out2, output [3:0] out3, output [3:0] out4);  
    wire [3:0] min_ab, min_cd, max_ab, max_cd;  
    wire [3:0] min_ac, min_ad, min_bc, min_bd, max_ac, max_ad, max_bc, max_bd;  
    wire [3:0] mid1, mid2;  

    assign min_ab = (a < b) ? a : b;  
    assign max_ab = (a < b) ? b : a;  
    assign min_cd = (c < d) ? c : d;  
    assign max_cd = (c < d) ? d : c;  

    assign out1 = (min_ab < min_cd) ? min_ab : min_cd;  
    assign out4 = (min_ab < min_cd) ? min_cd : min_ab;  

    assign mid1 = (min_ab < min_cd) ? max_ab : min_cd;  
    assign mid2 = (min_ab < min_cd) ? min_cd : max_ab;  

    assign out2 = (mid1 < mid2) ? mid1 : mid2;  
    assign out3 = (mid1 < mid2) ? mid2 : mid1;  
endmodule