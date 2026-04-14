module interrupt_controller(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] irq,  
    input wire enable,  
    output reg irq_out,  
    output reg ack  
);  
    reg [3:0] irq_reg;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            irq_out <= 0;  
            ack <= 0;  
            irq_reg <= 0;  
        end else if (enable) begin  
            irq_reg <= irq;  
            if (irq_reg != 0) begin  
                irq_out <= irq_reg[3] ? 3 :  
                            irq_reg[2] ? 2 :  
                            irq_reg[1] ? 1 :  
                            irq_reg[0] ? 0 : 0;  
                ack <= 1;  
            end else begin  
                ack <= 0;  
            end  
        end  
    end  
endmodule