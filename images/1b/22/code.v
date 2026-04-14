module master_slave_d_latch (  
    input D,  
    input CLK,  
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