module gpio_controller (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire read_enable,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_reg <= 4'b0000;
        end else begin
            if (write_enable) begin
                data_reg <= data_in;
            end
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= data_reg;
        end
    end
endmodule