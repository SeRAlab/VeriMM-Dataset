module master_slave_d_latch(  
    input D,  
    input CLK,  
    output reg Q,  
    output reg Qn  
);  
    reg master, slave;  

    always @(posedge CLK) begin  
        master <= D;  
    end  

    always @(negedge CLK) begin  
        slave <= master;  
        Q <= slave;  
        Qn <= ~slave;  
    end  
endmodule