module gpio_controller (
    input wire clk,
    input wire control,
    input wire [4:0] data_in,
    output reg [4:0] gpio_out
);

always @(posedge clk) begin
    if (control) begin
        gpio_out <= data_in; // Set GPIO pins
    end else begin
        gpio_out <= 5'b00000; // Clear GPIO pins
    end
end

endmodule