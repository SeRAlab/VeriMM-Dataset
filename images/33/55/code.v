module InterruptController(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] irq, // 4 interrupt request lines  
    output reg [3:0] irq_ack // Acknowledgement for the highest priority IRQ  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            irq_ack <= 4'b0000;  
        end else begin  
            case (irq)  
                4'b0001: irq_ack <= 4'b0001; // Priority 0  
                4'b0010: irq_ack <= 4'b0010; // Priority 1  
                4'b0100: irq_ack <= 4'b0100; // Priority 2  
                4'b1000: irq_ack <= 4'b1000; // Priority 3  
                default: irq_ack <= 4'b0000; // No valid IRQ  
            endcase  
        end  
    end  
endmodule