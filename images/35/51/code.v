module MasterSlaveDLatch (  
    input D,  
    input CLK,  
    output reg Q  
);  
    reg Q_master;  
    always @(posedge CLK) begin  
        Q_master <= D;  
    end  
    always @(negedge CLK) begin  
        Q <= Q_master;  
    end  
endmodule