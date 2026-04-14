module sr_latch(  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q,  
    output wire Q_bar  
);  
    assign Q_bar = ~Q;  

    always @(posedge clk) begin  
        if (S && R) begin  
            // Invalid state  
        end else if (S) begin  
            Q <= 1;  
        end else if (R) begin  
            Q <= 0;  
        end  
        // If both S and R are low, Q retains its state  
    end  
endmodule