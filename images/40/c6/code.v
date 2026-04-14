module gpio_controller (
    input wire clk,
    input wire reset,
    input wire mode, // 0 for output mode, 1 for input mode
    input wire [4:0] gpio_input, // GPIO input pins
    output reg [4:0] gpio_output // GPIO output pins
);

    reg [4:0] gpio_reg; // Register to hold GPIO value

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_reg <= 5'b00000; // Initialize register to zero
            gpio_output <= 5'b00000; // Initialize output to zero
        end else begin
            if (mode) begin
                gpio_reg <= gpio_input; // Read input into register
            end else begin
                gpio_output <= gpio_reg; // Output the value from the register
            end
        end
    end

endmodule