module merge_sort_4(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out1,
    output [7:0] out2,
    output [7:0] out3,
    output [7:0] out4
);
    
    wire [7:0] min1, min2, max1, max2;
    
    assign min1 = (a < b) ? a : b;
    assign max1 = (a < b) ? b : a;
    
    assign min2 = (c < d) ? c : d;
    assign max2 = (c < d) ? d : c;
    
    assign out1 = (min1 < min2) ? min1 : min2;
    assign out4 = (min1 < min2) ? min2 : min1;
    
    assign out2 = (max1 < min2) ? max1 : min2;
    assign out3 = (max1 < min2) ? min2 : max1;
    
    assign out2 = (out2 == out1) ? max1 : out2;
    
endmodule