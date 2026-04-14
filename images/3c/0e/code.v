module interrupt_controller (  
    input wire clk,  
    input wire rst_n,  
    input wire [3:0] irq, // 4 IRQs  
    output reg [3:0] active_irq,  
    output reg irq_ack  
);  
  
    reg [3:0] irq_pending;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            active_irq <= 4'b0000;  
            irq_ack <= 1'b0;  
            irq_pending <= 4'b0000;  
        end else begin  
            irq_pending <= irq;  
            if (irq_pending != 4'b0000 && active_irq == 4'b0000) begin  
                active_irq <= irq_pending;  
                irq_ack <= 1'b1;  
            end else if (irq_ack) begin  
                active_irq <= 4'b0000;  
                irq_ack <= 1'b0;  
            end  
        end  
    end  
endmodule