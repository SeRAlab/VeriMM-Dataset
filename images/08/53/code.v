module gpio_controller (
    input  [4:0] gpio_input,
    output [4:0] gpio_output
);
    assign gpio_output = ~gpio_input; // Invert the input
endmodule