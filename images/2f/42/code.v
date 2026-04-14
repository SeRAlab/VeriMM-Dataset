module gpio_controller(
    input wire clk,
    input wire rst,
    input wire mode,          // 0 for input mode, 1 for output mode
    input wire [4:0] data_in, // Data to be read
    output reg [4:0] data_out // Data to be written to GPIO
);
    reg [4:0] gpio_reg;       // Register to hold GPIO data

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_reg <= 5'b00000; // Reset the register
            data_out <= 5'b00000; // Reset output
        end else begin
            if (mode) begin
                data_out <= gpio_reg; // Output mode
            end else begin
                gpio_reg <= data_in;   // Input mode
            end
        end
    end
endmodule