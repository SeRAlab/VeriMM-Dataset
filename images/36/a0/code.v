module sr_latch (  
    input wire S,  
    input wire R,  
    output reg Q,  
    output reg Q_not  
);  
    always @ (S or R) begin  
        if (S && !R) begin  
            Q <= 1;  
            Q_not <= 0;  
        end else if (!S && R) begin  
            Q <= 0;  
            Q_not <= 1;  
        end  
    end  
endmodule