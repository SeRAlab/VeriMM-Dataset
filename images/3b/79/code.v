module master_slave_d_latch(  
    input wire D,  
    input wire E,  
    input wire CLK,  
    output reg Q  
);  
    reg master;  
    always @(posedge CLK) begin  
        if (E)  
            master <= D;  
    end  
    always @(negedge CLK) begin  
        Q <= master;  
    end  
endmodule