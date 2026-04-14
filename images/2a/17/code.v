module median_filter(input [7:0] in0, input [7:0] in1, input [7:0] in2, input [7:0] in3, input [7:0] in4, output [7:0] median);  
    wire [7:0] sorted [0:4];  
    assign sorted[0] = (in0 < in1) ? ((in1 < in2) ? in1 : ((in0 < in2) ? in2 : in0)) : ((in0 < in2) ? in0 : ((in1 < in2) ? in2 : in1));  
    assign sorted[1] = (in0 < in1) ? ((in1 < in3) ? in1 : ((in0 < in3) ? in3 : in0)) : ((in0 < in3) ? in0 : ((in1 < in3) ? in3 : in1));  
    assign sorted[2] = (in0 < in2) ? ((in2 < in3) ? in2 : ((in0 < in3) ? in3 : in0)) : ((in0 < in3) ? in0 : ((in2 < in3) ? in3 : in2));  
    assign sorted[3] = (in1 < in2) ? ((in2 < in4) ? in2 : ((in1 < in4) ? in4 : in1)) : ((in1 < in4) ? in1 : ((in2 < in4) ? in4 : in2));  
    assign sorted[4] = (in3 < in4) ? in3 : in4;  
    assign median = (sorted[2]);  
endmodule