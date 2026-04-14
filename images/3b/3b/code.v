module gpio_controller(
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] gpio;

    always @(posedge clk) begin
        if (write_enable) begin
            gpio <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= gpio;
        end
    end
endmodule