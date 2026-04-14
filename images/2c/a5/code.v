module jk_latch (  
    input J,  
    input K,  
    input E,  
    output reg Q  
);  
    always @(posedge E) begin  
        if (J && !K)  
            Q <= 1;  
        else if (!J && K)  
            Q <= 0;  
        else if (J && K)  
            Q <= ~Q;  
    end  
endmodule