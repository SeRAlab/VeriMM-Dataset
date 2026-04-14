module interrupt_controller(  
    input wire CLK,  
    input wire RST,  
    input wire [3:0] IRQ, // 4 interrupt requests  
    output reg [3:0] current_irq,  
    output reg ACK  
);  
    reg [3:0] irq_reg;  

    always @(posedge CLK or posedge RST) begin  
        if (RST) begin  
            current_irq <= 4'b0000;  
            ACK <= 0;  
        end else begin  
            irq_reg <= IRQ;  
            if (|irq_reg) begin // If any IRQ is active  
                current_irq <= irq_reg;  
                ACK <= 1;  
            end else begin  
                ACK <= 0;  
            end  
        end  
    end  
endmodule