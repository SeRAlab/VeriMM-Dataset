module gpio_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    input wire write_enable,
    input wire read_enable,
    output reg [3:0] data_out
);
    reg [3:0] gpio_pins;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_pins <= 4'b0000;
            data_out <= 4'b0000;
        end else begin
            if (write_enable) begin
                gpio_pins <= data_in;
            end
            if (read_enable) begin
                data_out <= gpio_pins;
            end
        end
    end
endmodule