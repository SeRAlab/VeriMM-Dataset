module comparator_4bit(  
    input [3:0] A,  
    input [3:0] B,  
    output reg lt,  
    output reg eq,  
    output reg gt  
);  

always @(*) begin  
    if (A < B) begin  
        lt = 1;  
        eq = 0;  
        gt = 0;  
    end else if (A == B) begin  
        lt = 0;  
        eq = 1;  
        gt = 0;  
    end else begin  
        lt = 0;  
        eq = 0;  
        gt = 1;  
    end  
end  
endmodule