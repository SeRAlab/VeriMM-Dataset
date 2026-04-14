module merge_sort_4inputs (  
    input [3:0] a,  
    input [3:0] b,  
    input [3:0] c,  
    input [3:0] d,  
    output [15:0] sorted  
);  
    wire [3:0] min1, min2, min3, max1, max2;  
    wire [3:0] mid1, mid2;  
   
    // Find minimum and maximum among a, b, c, d  
    assign min1 = (a < b) ? a : b;  
    assign max1 = (a > b) ? a : b;  
    assign min2 = (c < d) ? c : d;  
    assign max2 = (c > d) ? c : d;  
   
    assign mid1 = (min1 < min2) ? min1 : min2;  
    assign mid2 = (min1 > min2) ? min1 : min2;  
   
    // Final sorted output  
    assign sorted = {max1, mid2, mid1, min2};  
endmodule