module gpio_controller(  
    input [4:0] gpio_in,  
    input enable,  
    output [4:0] gpio_out  
);  
    assign gpio_out = enable ? ~gpio_in : 5'b00000;  
endmodule