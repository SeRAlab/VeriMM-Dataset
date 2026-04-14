module comparator_64bit (  
    input [63:0] A,  
    input [63:0] B,  
    output reg A_gt_B,  
    output reg A_lt_B,  
    output reg A_eq_B  
);  
    always @(*) begin  
        A_gt_B = (A > B) ? 1'b1 : 1'b0;  
        A_lt_B = (A < B) ? 1'b1 : 1'b0;  
        A_eq_B = (A == B) ? 1'b1 : 1'b0;  
    end  
endmodule