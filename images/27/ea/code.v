module gpio_controller (
    input wire clk,
    input wire reset,
    input wire read_en,
    input wire [7:0] gpio_pins,
    output reg [7:0] gpio_state
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        gpio_state <= 8'b00000000; // Reset the state
    end else if (read_en) begin
        gpio_state <= gpio_pins; // Read GPIO pins into state
    end
end

endmodule