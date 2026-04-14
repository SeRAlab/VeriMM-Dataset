module sr_latch (  
    input wire S,  
    input wire R,  
    output reg Q,  
    output wire Qn  
);  
    assign Qn = ~Q;  

    always @(S, R) begin  
        if (S && ~R)  
            Q <= 1'b1;  
        else if (~S && R)  
            Q <= 1'b0;  
        // If both S and R are low, keep the previous state (no action)  
    end  
endmodule