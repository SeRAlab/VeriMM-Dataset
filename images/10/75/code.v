module gpio_controller(  
    input wire clk,  
    input wire enable,  
    input wire gpio_in,  
    output reg gpio_out  
);  
    always @(posedge clk) begin  
        if (enable)  
            gpio_out <= gpio_in;  
    end  
endmodule