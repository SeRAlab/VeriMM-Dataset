module merge_sort_4input(  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    input [3:0] D,  
    output [3:0] O1,  
    output [3:0] O2,  
    output [3:0] O3,  
    output [3:0] O4  
);  
    wire [3:0] min1, min2, max1, max2;  
    wire [3:0] mid1, mid2;  

    // Finding the minimum and maximum values  
    assign min1 = (A < B) ? A : B;  
    assign max1 = (A < B) ? B : A;  
    assign min2 = (C < D) ? C : D;  
    assign max2 = (C < D) ? D : C;  

    // Finding the first two outputs  
    assign O1 = (min1 < min2) ? min1 : min2;  
    assign mid1 = (min1 < min2) ? min2 : min1;  
    assign O2 = (mid1 < max1) ? mid1 : max1;  

    // Finding the next two outputs  
    assign O3 = (mid1 < max1) ? max1 : mid1;  
    assign O4 = (max1 < max2) ? max2 : max1;  
endmodule