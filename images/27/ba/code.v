module JK_flip_flop (  
    input J,  
    input K,  
    input clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (J && K)  
            Q <= ~Q;  // Toggle  
        else if (J)  
            Q <= 1;   // Set  
        else if (K)  
            Q <= 0;   // Reset  
    end  
endmodule