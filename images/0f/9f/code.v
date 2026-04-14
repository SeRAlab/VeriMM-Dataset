module comparator_64bit(  
    input [63:0] A,  
    input [63:0] B,  
    output reg equal,  
    output reg greater,  
    output reg less  
);  
    always @(*) begin  
        if (A == B) begin  
            equal = 1'b1;  
            greater = 1'b0;  
            less = 1'b0;  
        end else if (A > B) begin  
            equal = 1'b0;  
            greater = 1'b1;  
            less = 1'b0;  
        end else begin  
            equal = 1'b0;  
            greater = 1'b0;  
            less = 1'b1;  
        end  
    end  
endmodule