module interrupt_controller(  
    input wire clk,  
    input wire rst,  
    input wire interrupt,  
    output reg irq  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            irq <= 0;  
        else if (interrupt)  
            irq <= 1;  
    end  
endmodule