module sr_latch (  
    input S,  
    input R,  
    output reg Q,  
    output Qn  
);  
    assign Qn = ~Q;  
    always @ (S or R) begin  
        if (S && ~R)  
            Q <= 1;  
        else if (~S && R)  
            Q <= 0;  
        // If both are 0, maintain the previous state  
    end  
endmodule