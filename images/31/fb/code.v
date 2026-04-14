module decision_tree(input [3:0] A, B, C, output reg Y);  
always @(*) begin  
    if (A > 4'b0010)  
        Y = 1'b1;  
    else if (A <= 4'b0010 && B > 4'b0011)  
        Y = 1'b1;  
    else if (A <= 4'b0010 && B <= 4'b0011 && C > 4'b0001)  
        Y = 1'b0;  
    else  
        Y = 1'b0;  
end  
endmodule