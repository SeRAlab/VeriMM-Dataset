module comparator_4bit (  
    input [3:0] A,  
    input [3:0] B,  
    output reg lt,  
    output reg gt,  
    output reg eq  
);  
    always @(*) begin  
        lt = 0;  
        gt = 0;  
        eq = 0;  
        if (A < B) begin  
            lt = 1;  
        end else if (A > B) begin  
            gt = 1;  
        end else begin  
            eq = 1;  
        end  
    end  
endmodule