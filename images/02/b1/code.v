module master_slave_d_latch(  
    input wire D,  
    input wire CLK,  
    output reg Q  
);  
    reg master;  
    always @(posedge CLK) begin  
        master <= D;  
    end  
    always @(negedge CLK) begin  
        Q <= master;  
    end  
endmodule