module gpio_controller (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [7:0] data_in,
    input wire [7:0] pin_config, // 1 for output, 0 for input
    input wire read_enable,
    output reg [7:0] data_out
);
    reg [7:0] gpio_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_state <= 8'b00000000;
            data_out <= 8'b00000000;
        end else if (enable) begin
            if (read_enable) begin
                data_out <= gpio_state;
            end else begin
                gpio_state <= (pin_config & data_in) | (gpio_state & ~pin_config);
            end
        end
    end
endmodule