module JK_latch(  
    input J,  
    input K,  
    input clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (J && !K)  
            Q <= 1;  
        else if (!J && K)  
            Q <= 0;  
        else if (J && K)  
            Q <= ~Q;  
    end  
endmodule