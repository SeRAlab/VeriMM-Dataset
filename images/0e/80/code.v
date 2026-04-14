module JK_latch (  
    input J,  
    input K,  
    input clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (J && K)  
            Q <= ~Q;  
        else if (J)  
            Q <= 1;  
        else if (K)  
            Q <= 0;  
        // retain previous state if both J and K are low  
    end  
endmodule