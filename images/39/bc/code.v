module gpio_controller (
    input wire clk,
    input wire rst,
    input wire mode, // 0 for input, 1 for output
    input wire [4:0] data_out,
    output reg [4:0] data_in,
    output reg [4:0] gpio_pins
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_pins <= 5'b00000;
        end else if (mode) begin
            gpio_pins <= data_out;
        end else begin
            data_in <= gpio_pins;
        end
    end
endmodule