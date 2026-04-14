module JK_latch (  
    input J,  
    input K,  
    input Enable,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge Enable) begin  
        if (J && !K)  
            Q <= 1;  
        else if (!J && K)  
            Q <= 0;  
        else if (J && K)  
            Q <= ~Q;  
        Qn <= ~Q;  
    end  
endmodule