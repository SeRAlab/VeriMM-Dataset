module sr_latch (  
    input wire S,  
    input wire R,  
    output reg Q,  
    output wire Qn  
);  
    assign Qn = ~Q;  
    
    always @(S, R) begin  
        if (S && !R)  
            Q <= 1;  
        else if (!S && R)  
            Q <= 0;  
        else if (S && R)  
            Q <= Q;  // Invalid state, hold previous state  
    end  
endmodule