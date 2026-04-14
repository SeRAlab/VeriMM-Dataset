module interrupt_controller(  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [3:0] irq,  
    output reg [3:0] active_irq  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            active_irq <= 4'b0000;  
        end else if (enable) begin  
            case (irq)  
                4'b0001: active_irq <= 4'b0001;  
                4'b0010: active_irq <= 4'b0010;  
                4'b0100: active_irq <= 4'b0100;  
                4'b1000: active_irq <= 4'b1000;  
                default: active_irq <= 4'b0000;  
            endcase  
        end  
    end  
endmodule