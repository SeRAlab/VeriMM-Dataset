module master_slave_d_latch (  
    input wire D,  
    input wire CLK,  
    output reg Q,  
    output reg Qn  
);  
    reg master;  
    always @(posedge CLK) begin  
        master <= D;  
    end  
    always @(posedge CLK) begin  
        Q <= master;  
        Qn <= ~master;  
    end  
endmodule