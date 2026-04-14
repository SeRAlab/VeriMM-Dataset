module interrupt_controller (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] irq,  
    output reg [1:0] ack_irq  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ack_irq <= 2'b00;  
        end else begin  
            case (1'b1)  
                irq[3]: ack_irq <= 2'b11; // Acknowledge IRQ 3  
                irq[2]: ack_irq <= 2'b10; // Acknowledge IRQ 2  
                irq[1]: ack_irq <= 2'b01; // Acknowledge IRQ 1  
                irq[0]: ack_irq <= 2'b00; // Acknowledge IRQ 0  
                default: ack_irq <= ack_irq; // No change  
            endcase  
        end  
    end  
endmodule