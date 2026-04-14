module gpio_controller(  
    input clk,  
    input reset,  
    input control,  
    output reg gpio_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            gpio_out <= 0;  
        else if (control)  
            gpio_out <= 1;  
        else  
            gpio_out <= 0;  
    end  
endmodule