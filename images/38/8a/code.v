module sr_latch(  
    input wire S,  
    input wire R,  
    output reg Q,  
    output reg Q_bar  
);  
    always @ (S, R) begin  
        if (S && ~R) begin  
            Q <= 1;  
            Q_bar <= 0;  
        end  
        else if (~S && R) begin  
            Q <= 0;  
            Q_bar <= 1;  
        end  
        // Invalid condition will keep the previous state  
    end  
endmodule