module merge_sort_4way (  
    input [3:0] a,  
    input [3:0] b,  
    input [3:0] c,  
    input [3:0] d,  
    output [15:0] out  
);  
    wire [7:0] mid1, mid2;  
    wire [3:0] min1, min2, min3, min4;  

    // Concatenate inputs  
    assign mid1 = {a, b};  
    assign mid2 = {c, d};  

    // Sort first half  
    assign min1 = (mid1[3:0] < mid1[7:4]) ? mid1[3:0] : mid1[7:4];  
    assign min2 = (mid1[3:0] < mid1[7:4]) ? mid1[7:4] : mid1[3:0];  

    // Sort second half  
    assign min3 = (mid2[3:0] < mid2[7:4]) ? mid2[3:0] : mid2[7:4];  
    assign min4 = (mid2[3:0] < mid2[7:4]) ? mid2[7:4] : mid2[3:0];  

    // Final output sorting  
    assign out[15:12] = (min1 < min3) ? min1 : min3;  
    assign out[11:8]  = (min1 < min3) ? (min2 < min3 ? min2 : min3) : (min2 < min1 ? min2 : min1);  
    assign out[7:4]   = (min1 < min3) ? (min2 < min3 ? min3 : min2) : (min2 < min1 ? min1 : min2);  
    assign out[3:0]   = (min1 < min3) ? min4 : min2;  

endmodule