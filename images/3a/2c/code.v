module interrupt_controller(  
    input wire clk,  
    input wire reset,  
    input wire IRQ1,  
    input wire IRQ2,  
    output reg IRQ_OUT  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IRQ_OUT <= 0;  
        end else begin  
            IRQ_OUT <= IRQ1 | IRQ2;  
        end  
    end  
endmodule