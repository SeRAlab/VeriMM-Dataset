module gpio_controller (
    input [4:0] gpio_input,
    output reg [4:0] gpio_output
);

always @(*) begin
    if (gpio_input == 5'b00000) begin
        gpio_output = 5'b00000; // All pins LOW
    end else if (gpio_input == 5'b11111) begin
        gpio_output = 5'b11111; // All pins HIGH
    end else begin
        gpio_output = gpio_input; // Directly match input
    end
end

endmodule