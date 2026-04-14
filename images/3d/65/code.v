module master_slave_d_latch (  
    input wire D,  
    input wire E,  
    input wire C,  
    output reg Q  
);  
    reg master;  
    always @ (E or D) begin  
        if (E)  
            master = D;  
    end  
    always @ (posedge C) begin  
        Q <= master;  
    end  
endmodule