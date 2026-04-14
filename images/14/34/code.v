module JK_latch (  
    input J,  
    input K,  
    input CLK,  
    output reg Q  
);  
    always @(posedge CLK) begin  
        if (J && ~K)  
            Q <= 1;  // Set  
        else if (~J && K)  
            Q <= 0;  // Reset  
        else if (J && K)  
            Q <= ~Q; // Toggle  
    end  
endmodule