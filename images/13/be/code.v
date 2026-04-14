module sr_latch (  
    input wire S,  
    input wire R,  
    output reg Q,  
    output reg Qn  
);  
    always @(S, R) begin  
        if (S == 1 && R == 0) begin  
            Q = 1;  
            Qn = 0;  
        end  
        else if (S == 0 && R == 1) begin  
            Q = 0;  
            Qn = 1;  
        end  
        // Retain state if both inputs are 0  
        // Indeterminate condition handled as no change  
    end  
endmodule