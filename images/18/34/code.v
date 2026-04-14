module comparator_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    output reg A_gt_B,  
    output reg A_eq_B  
);  
    always @(*) begin  
        A_gt_B = (A > B);  
        A_eq_B = (A == B);  
    end  
endmodule