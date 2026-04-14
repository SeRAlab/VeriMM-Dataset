module gpio_controller (
    input wire clk,
    input wire rst,
    input wire [4:0] data_in,
    input wire wr_en,
    output reg [4:0] gpio_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_out <= 5'b00000; // Reset GPIO pins to 0
        end else if (wr_en) begin
            gpio_out <= data_in; // Write data to GPIO pins
        end
    end
endmodule