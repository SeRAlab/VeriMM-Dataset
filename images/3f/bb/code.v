module JK_Latch (  
    input J,  
    input K,  
    input E,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge E) begin  
        if (J == 1'b0 && K == 1'b0) begin  
            // Maintain state  
            Qn <= ~Q;  
        end else if (J == 1'b1 && K == 1'b0) begin  
            // Set state  
            Q <= 1'b1;  
        end else if (J == 1'b0 && K == 1'b1) begin  
            // Reset state  
            Q <= 1'b0;  
        end else if (J == 1'b1 && K == 1'b1) begin  
            // Toggle state  
            Q <= ~Q;  
        end  
        Qn <= ~Q;  
    end  
endmodule