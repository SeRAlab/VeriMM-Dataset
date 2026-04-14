module JK_latch (  
    input J,  
    input K,  
    input Enable,  
    output reg Q,  
    output reg Qn  
);  
    always @ (J or K or Enable) begin  
        if (Enable) begin  
            if (J && !K) begin  
                Q <= 1;  
            end else if (!J && K) begin  
                Q <= 0;  
            end else if (J && K) begin  
                Q <= ~Q;  
            end  
        end  
        Qn <= ~Q;  
    end  
endmodule