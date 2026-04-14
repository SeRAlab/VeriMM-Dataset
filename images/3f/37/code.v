module interrupt_controller(  
    input clk,  
    input rst,  
    input irq0,  
    input irq1,  
    input irq2,  
    output reg ack  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        ack <= 0;  
    end else begin  
        ack <= irq0 | irq1 | irq2;  
    end  
end  

endmodule