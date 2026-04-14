module interrupt_controller (  
    input wire clk,  
    input wire rst_n,  
    input wire [3:0] irq,  
    input wire clear,  
    output reg [1:0] irq_index  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            irq_index <= 2'b11; // Invalid state  
        end else if (clear) begin  
            irq_index <= 2'b11; // Reset to invalid state  
        end else begin  
            case (irq)  
                4'b0001: irq_index <= 2'b00; // IRQ0  
                4'b0010: irq_index <= 2'b01; // IRQ1  
                4'b0100: irq_index <= 2'b10; // IRQ2  
                4'b1000: irq_index <= 2'b11; // IRQ3  
                4'b0011: irq_index <= 2'b00; // IRQ0 or IRQ1, choose IRQ0  
                4'b0110: irq_index <= 2'b01; // IRQ1 or IRQ2, choose IRQ1  
                4'b1100: irq_index <= 2'b00; // IRQ0 or IRQ3, choose IRQ0  
                4'b1111: irq_index <= 2'b00; // All, choose IRQ0  
                default: irq_index <= 2'b11; // Invalid  
            endcase  
        end  
    end  
endmodule