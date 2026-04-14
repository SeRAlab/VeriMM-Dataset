module interrupt_controller(  
    input wire clk,  
    input wire [3:0] irq,  
    output reg interrupt,  
    output reg [1:0] irq_vector  
);  
    reg [3:0] irq_reg;  
    reg [1:0] current_irq;  

    always @(posedge clk) begin  
        // Register the incoming IRQ signals  
        irq_reg <= irq;  
        // Check for active IRQs  
        if (|irq_reg) begin  
            // Prioritize the highest IRQ signal  
            case (irq_reg)  
                4'b0001: begin  
                    interrupt <= 1;  
                    irq_vector <= 2'b00;  
                end  
                4'b0010: begin  
                    interrupt <= 1;  
                    irq_vector <= 2'b01;  
                end  
                4'b0100: begin  
                    interrupt <= 1;  
                    irq_vector <= 2'b10;  
                end  
                4'b1000: begin  
                    interrupt <= 1;  
                    irq_vector <= 2'b11;  
                end  
                default: begin  
                    interrupt <= 0;  
                    irq_vector <= 2'b00;  
                end  
            endcase  
        end else begin  
            interrupt <= 0;  
            irq_vector <= 2'b00;  
        end  
    end  
endmodule