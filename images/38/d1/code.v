module gpio_controller (
    input wire clk,
    input wire rst,
    input wire [4:0] data_in,
    input wire read_enable,
    input wire write_enable,
    output reg [4:0] data_out
);
    reg [4:0] gpio_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_reg <= 5'b00000;
            data_out <= 5'b00000;
        end else begin
            if (write_enable) begin
                gpio_reg <= data_in;
            end
            if (read_enable) begin
                data_out <= gpio_reg;
            end
        end
    end
endmodule