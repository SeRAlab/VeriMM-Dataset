module master_slave_d_latch (  
    input wire clk,  
    input wire d,  
    output reg q  
);  
    reg q_master;  
    
    always @(posedge clk) begin  
        q_master <= d;  
    end  
    
    always @(negedge clk) begin  
        q <= q_master;  
    end  
endmodule