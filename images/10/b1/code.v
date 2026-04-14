module interrupt_controller(  
    input clk,  
    input rst_n,  
    input irq0,  
    input irq1,  
    input irq2,  
    input irq3,  
    output reg interrupt_out  
);  

always @(posedge clk or negedge rst_n) begin  
    if (!rst_n)  
        interrupt_out <= 0;  
    else begin  
        if (irq0)  
            interrupt_out <= 1;  
        else if (irq1)  
            interrupt_out <= 2;  
        else if (irq2)  
            interrupt_out <= 3;  
        else if (irq3)  
            interrupt_out <= 4;  
        else  
            interrupt_out <= 0;  
    end  
end  
endmodule