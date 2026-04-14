module master_slave_d_latch(  
    input wire D,  
    input wire E,  
    output reg Q,  
    output reg QN  
);  
    reg master;  
    always @(posedge E) begin  
        master <= D;  
    end  
    always @(negedge E) begin  
        Q <= master;  
        QN <= ~master;  
    end  
endmodule