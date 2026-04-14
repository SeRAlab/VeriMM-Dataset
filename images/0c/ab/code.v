module gpio_controller (
    input clk,
    input rst,
    input [4:0] dir,         // Direction register: 1 for output, 0 for input
    input [4:0] write_data,  // Data to write to output pins
    input read_enable,        // Signal to read the state of the input pins
    output reg [4:0] read_data, // Data read from input pins
    output reg [4:0] output_status // Current status of the output pins
);

reg [4:0] direction_reg; // Register to hold the direction of each pin

always @(posedge clk or posedge rst) begin
    if (rst) begin
        direction_reg <= 5'b00000; // Reset direction register
        output_status <= 5'b00000;  // Reset output status
    end else begin
        direction_reg <= dir; // Update direction register
        output_status <= write_data & direction_reg; // Update output status based on direction
    end
end

always @(posedge clk) begin
    if (read_enable) begin
        read_data <= output_status; // Read output status if enabled
    end
end

endmodule