module gpio_controller (
    input wire clk,
    input wire rst_n,
    input wire write_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 8'b0;
            data_out <= 8'b0;
        end else if (write_enable) begin
            data_reg <= data_in;
            data_out <= data_reg;
        end
    end
endmodule