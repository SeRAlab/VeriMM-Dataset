module jk_flip_flop (  
    input J,  
    input K,  
    input clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (J && !K)  
            Q <= 1; // Set  
        else if (!J && K)  
            Q <= 0; // Reset  
        else if (J && K)  
            Q <= ~Q; // Toggle  
        // If J = 0 and K = 0, Q remains the same  
    end  
endmodule