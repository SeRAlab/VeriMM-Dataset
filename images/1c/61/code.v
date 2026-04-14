module gpio_controller(  
    input wire clk,  
    input wire enable,  
    input wire set,  
    input wire reset,  
    output reg gpio_pin  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            if (reset)  
                gpio_pin <= 1'b0;  
            else if (set)  
                gpio_pin <= 1'b1;  
        end  
    end  
endmodule