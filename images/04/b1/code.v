module interrupt_controller(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] irq,  // 4 interrupt requests  
    output reg int_serviced  // Interrupt serviced signal  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            int_serviced <= 0;  
        end else begin  
            if (|irq) begin  // If any IRQ is high  
                int_serviced <= 1;  
            end else begin  
                int_serviced <= 0;  
            end  
        end  
    end  
endmodule