module gpio_controller(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] GPIO_OUT,  
    input wire write_enable,  
    output reg [3:0] GPIO_IN  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            GPIO_IN <= 4'b0000;  
        else if (write_enable)  
            GPIO_IN <= GPIO_OUT;  
    end  
endmodule