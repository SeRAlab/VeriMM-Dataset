module merge_sort_4way(  
    input [7:0] a,  
    input [7:0] b,  
    input [7:0] c,  
    input [7:0] d,  
    output [31:0] sorted_output  
);  
    wire [7:0] merged_ab, merged_cd;  
    wire [15:0] merged_abc;  
   
    assign merged_ab = (a < b) ? a : b;  
    assign merged_ab = (a >= b) ? b : a;  
   
    assign merged_cd = (c < d) ? c : d;  
    assign merged_cd = (c >= d) ? d : c;  
   
    assign merged_abc = (merged_ab < merged_cd) ? {merged_ab, merged_cd} : {merged_cd, merged_ab};  
   
    assign sorted_output = {merged_abc, 8'b0};  
endmodule