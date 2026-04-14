module gpio_controller (  
    input [4:0] gpio_in,  
    output [4:0] gpio_out  
);  
    assign gpio_out = gpio_in;  
endmodule