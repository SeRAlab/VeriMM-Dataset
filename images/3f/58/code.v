module interrupt_controller (  
    input wire clk,  
    input wire IRQ0,  
    input wire IRQ1,  
    input wire IRQ2,  
    input wire IRQ3,  
    output reg [3:0] IRQ_OUT  
);  
    always @(posedge clk) begin  
        if (IRQ0)  
            IRQ_OUT <= 4'b0001;  
        else if (IRQ1)  
            IRQ_OUT <= 4'b0010;  
        else if (IRQ2)  
            IRQ_OUT <= 4'b0100;  
        else if (IRQ3)  
            IRQ_OUT <= 4'b1000;  
        else  
            IRQ_OUT <= 4'b0000;  
    end  
endmodule