module SR_Latch_DFF(  
    input wire S,  
    input wire R,  
    input wire Enable,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge Enable) begin  
        if (S && !R) begin  
            Q <= 1;  
            Qn <= 0;  
        end  
        else if (!S && R) begin  
            Q <= 0;  
            Qn <= 1;  
        end  
        // If S == 0 and R == 0, maintain state  
        // If S == 1 and R == 1, this case should not occur  
    end  
endmodule