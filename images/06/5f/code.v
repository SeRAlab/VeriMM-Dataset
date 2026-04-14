module interrupt_controller (  
    input clk,  
    input reset,  
    input IRQ,  
    input ack,  
    output reg interrupt_flag  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            interrupt_flag <= 0;  
        else if (IRQ)  
            interrupt_flag <= 1;  
        else if (ack)  
            interrupt_flag <= 0;  
    end  
endmodule