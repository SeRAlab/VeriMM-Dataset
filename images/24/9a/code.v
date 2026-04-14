module master_slave_d_latch (  
    input wire D,  
    input wire CLK,  
    input wire EN,  
    output reg Q  
);  

    reg Q_master;  

    // Master latch (transparent when CLK is high)
    always @(posedge CLK) begin  
        if (EN)  
            Q_master <= D;  
    end  

    // Slave latch (captures on falling edge)
    always @(negedge CLK) begin  
        if (EN)  
            Q <= Q_master;  
    end  
endmodule