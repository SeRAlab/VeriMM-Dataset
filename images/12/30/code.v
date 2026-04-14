module GPIO_Controller (
    input wire clk,
    input wire rst,
    input wire we,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] gpio_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_state <= 8'b00000000;
        end else if (we) begin
            gpio_state <= data_in;
        end
    end

    always @(*) begin
        data_out = gpio_state;
    end
endmodule