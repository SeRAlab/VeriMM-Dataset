module gpio_controller(  
    input [4:0] gpio_input,  
    input control_signal,  
    output [4:0] gpio_output  
);  
assign gpio_output = control_signal ? ~gpio_input : gpio_input;  
endmodule