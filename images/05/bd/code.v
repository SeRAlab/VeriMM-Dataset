module sr_latch (input wire S, input wire R, output reg Q, output wire Q_bar);  
    assign Q_bar = ~Q;  
    always @(S or R) begin  
        if (S && !R)  
            Q <= 1;  
        else if (!S && R)  
            Q <= 0;  
        else if (S && R)  
            Q <= 1'bx; // Invalid state  
    end  
endmodule