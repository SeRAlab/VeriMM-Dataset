module merge_sort_4inputs (  
    input [3:0] a,  
    input [3:0] b,  
    input [3:0] c,  
    input [3:0] d,  
    output [15:0] sorted  
);  
    wire [3:0] min1, min2, min3, min4;  
    wire [3:0] max1, max2, max3, max4;  

    // Compare inputs and find minimums  
    assign min1 = (a < b) ? a : b;  
    assign min2 = (c < d) ? c : d;  
    assign min3 = (min1 < min2) ? min1 : min2;  
    assign max1 = (a > b) ? a : b;  
    assign max2 = (c > d) ? c : d;  
    assign max3 = (max1 > max2) ? max1 : max2;  

    // Find second minimum  
    assign min4 = (min1 == min3) ? max1 : (min2 == min3) ? max2 : (min1 < min2) ? min2 : min1;  

    // Output sorted result  
    assign sorted = {max3, min3, min4};  

endmodule