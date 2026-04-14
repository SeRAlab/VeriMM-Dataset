module interrupt_controller(  
    input wire clk,  
    input wire irq,  
    output reg ack  
);  
    always @(posedge clk) begin  
        if (irq)  
            ack <= 1;  
        else  
            ack <= 0;  
    end  
endmodule