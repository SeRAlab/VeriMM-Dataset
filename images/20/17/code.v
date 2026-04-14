module gpio_controller (
    input clk,
    input rst,
    input [4:0] gpio_dir, // Direction register for 5 GPIO pins
    input [4:0] gpio_in,  // Input data for the GPIO pins
    input gpio_write_en,  // Enable writing to GPIO_DATA
    output reg [4:0] gpio_data // Data register holding GPIO state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_data <= 5'b00000; // Reset GPIO state
        end else begin
            if (gpio_write_en) begin
                gpio_data <= gpio_in; // Update GPIO_DATA if writing is enabled
            end
        end
    end
    
endmodule