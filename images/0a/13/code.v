module merge_sort(  
    input [3:0] a,  
    input [3:0] b,  
    input [3:0] c,  
    input [3:0] d,  
    output [3:0] out1,  
    output [3:0] out2,  
    output [3:0] out3,  
    output [3:0] out4  
);  

wire [3:0] temp1, temp2, temp3, temp4;  
wire [3:0] min1, min2, min3, min4;  

// First pair comparisons  
assign temp1 = (a < b) ? a : b;  
assign temp2 = (a < b) ? b : a;  

// Second pair comparisons  
assign temp3 = (c < d) ? c : d;  
assign temp4 = (c < d) ? d : c;  

// Final comparisons to get sorted output  
assign min1 = (temp1 < temp3) ? temp1 : temp3;  
assign out1 = min1;  
assign min2 = (temp1 < temp3) ? temp3 : temp1;  
assign min3 = (temp2 < temp4) ? temp2 : temp4;  
assign out2 = min3;  
assign min4 = (temp2 < temp4) ? temp4 : temp2;  
assign out3 = (min2 < min4) ? min2 : min4;  
assign out4 = (min2 < min4) ? min4 : min2;  

endmodule