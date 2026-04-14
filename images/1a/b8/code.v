module interrupt_controller(  
    input clk,  
    input reset,  
    input [3:0] irq,  
    input gie,  
    output reg [1:0] highest_irq  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            highest_irq <= 2'b00;  
        else if (gie) begin  
            if (irq[0])  
                highest_irq <= 2'b00;  // IRQ0  
            else if (irq[1])  
                highest_irq <= 2'b01;  // IRQ1  
            else if (irq[2])  
                highest_irq <= 2'b10;  // IRQ2  
            else if (irq[3])  
                highest_irq <= 2'b11;  // IRQ3  
            else   
                highest_irq <= 2'b00;  // No interrupts  
        end else begin  
            highest_irq <= 2'b00;  
        end  
    end  
endmodule