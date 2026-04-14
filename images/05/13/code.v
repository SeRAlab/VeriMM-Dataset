module magnitude_comparator(  
    input [3:0] A,  
    input [3:0] B,  
    output reg greater,  
    output reg less,  
    output reg equal  
);  
    always @* begin  
        if (A > B) begin  
            greater = 1;  
            less = 0;  
            equal = 0;  
        end else if (A < B) begin  
            greater = 0;  
            less = 1;  
            equal = 0;  
        end else begin  
            greater = 0;  
            less = 0;  
            equal = 1;  
        end  
    end  
endmodule