module gpio_controller(  
    input [4:0] gpio_input,  
    output reg [4:0] gpio_output  
);  
    always @(*) begin  
        gpio_output = gpio_input;  
    end  
endmodule