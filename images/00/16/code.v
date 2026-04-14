module JK_FF (  
    input J,  
    input K,  
    input CLK,  
    output reg Q  
);  
    always @(posedge CLK) begin  
        if (J && !K)  
            Q <= 1;  
        else if (!J && K)  
            Q <= 0;  
        else if (J && K)  
            Q <= ~Q;  
    end  
endmodule