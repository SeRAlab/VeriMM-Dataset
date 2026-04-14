module magnitude_comparator(  
    input [4:0] A,  
    input [4:0] B,  
    output reg A_greater,  
    output reg A_equal,  
    output reg A_less  
);  
  
always @(*) begin  
    A_greater = 0;  
    A_equal = 0;  
    A_less = 0;  
  
    if (A > B) begin  
        A_greater = 1;  
    end else if (A < B) begin  
        A_less = 1;  
    end else begin  
        A_equal = 1;  
    end  
end  
endmodule