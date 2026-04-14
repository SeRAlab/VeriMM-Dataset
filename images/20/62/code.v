module MasterSlaveDLatch(  
    input wire D,  
    input wire E,  
    output reg Q,  
    output reg Q_bar  
);  
    reg master;  
    always @(E or D) begin  
        if (E) begin  
            master <= D;  
        end  
    end  
    always @(negedge E) begin  
        Q <= master;  
        Q_bar <= ~master;  
    end  
endmodule