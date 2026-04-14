module gpio_controller(input [3:0] gpio_input, output [3:0] gpio_output);  
    assign gpio_output = ~gpio_input;  
endmodule