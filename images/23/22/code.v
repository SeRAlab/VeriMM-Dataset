module gpio_controller (
    input clk,
    input rst,
    input [7:0] data_in,
    input write_en,
    output reg [7:0] data_out
);
    reg [7:0] GPIO_REG;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            GPIO_REG <= 8'b0;
            data_out <= 8'b0;
        end else if (write_en) begin
            GPIO_REG <= data_in;
        end else begin
            data_out <= GPIO_REG;
        end
    end
endmodule