module gpio_controller (
    input wire gpio_input,
    input wire control,
    input wire reset,
    output reg gpio_output
);
    always @(*) begin
        if (reset) begin
            gpio_output = 0;
        end else if (control) begin
            gpio_output = gpio_input;
        end
        // If control is low, output remains unchanged (no assignment here)
    end
endmodule