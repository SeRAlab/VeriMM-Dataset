module gpio_controller (
    input [4:0] gpio_input,
    input control,
    output reg [4:0] gpio_output
);

always @(*) begin
    if (control) begin
        gpio_output = ~gpio_input; // Invert the GPIO input
    end else begin
        gpio_output = 5'b00000; // Output zero if control is low
    end
end
endmodule