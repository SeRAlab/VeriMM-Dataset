module JK_flip_flop (  
    input J,  
    input K,  
    input clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (J && K)  
            Q <= ~Q;  
        else if (J)  
            Q <= 1'b1;  
        else if (K)  
            Q <= 1'b0;  
        // If both J and K are low, retain the previous state (no action)  
    end  
endmodule