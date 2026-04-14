module master_slave_d_latch (  
    input wire D,  
    input wire C,  
    output reg Q  
);  
    reg Q_master;  
   
    always @(posedge C) begin  
        Q_master <= D;  
    end  
   
    always @(negedge C) begin  
        Q <= Q_master;  
    end  
endmodule