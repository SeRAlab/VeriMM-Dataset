module gpio_controller(  
    input wire clk,  
    input wire reset,  
    input wire gpio_pin,  
    output reg gpio_status  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            gpio_status <= 1'b0;  
        end else begin  
            gpio_status <= gpio_pin;  
        end  
    end  
endmodule