module interrupt_controller (  
    input clk,  
    input reset,  
    input enable,  
    input ext_interrupt,  
    input timer_interrupt,  
    output reg interrupt_flag  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        interrupt_flag <= 0;  
    end else if (enable) begin  
        if (ext_interrupt || timer_interrupt) begin  
            interrupt_flag <= 1;  
        end else begin  
            interrupt_flag <= 0;  
        end  
    end  
end  
endmodule