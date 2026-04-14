module merge_sort_4 (  
    input [7:0] a,  
    input [7:0] b,  
    input [7:0] c,  
    input [7:0] d,  
    output [7:0] sorted1,  
    output [7:0] sorted2,  
    output [7:0] sorted3,  
    output [7:0] sorted4  
);  

    wire [7:0] min1, min2, min3, max1, max2;  

    assign min1 = (a < b) ? a : b;  
    assign max1 = (a < b) ? b : a;  
    assign min2 = (c < d) ? c : d;  
    assign max2 = (c < d) ? d : c;  

    assign sorted1 = (min1 < min2) ? min1 : min2;  
    assign sorted4 = (min1 < min2) ? min2 : min1;  
    assign sorted2 = (max1 < min2) ? max1 : min2;  
    assign sorted3 = (max1 < min2) ? min2 : max1;  
    assign sorted3 = (sorted2 < sorted3) ? sorted2 : sorted3;  
    assign sorted2 = (sorted2 < sorted3) ? sorted2 : sorted3;  

endmodule